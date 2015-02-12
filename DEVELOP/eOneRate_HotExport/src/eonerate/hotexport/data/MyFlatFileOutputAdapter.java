package eonerate.hotexport.data;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.LineNumberReader;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Scanner;

import org.apache.commons.lang.StringUtils;

import ElcRate.CommonConfig;
import ElcRate.adapter.AbstractTransactionalOutputAdapter;
import ElcRate.adapter.jdbc.JDBCInputAdapter;
import ElcRate.configurationmanager.ClientManager;
import ElcRate.configurationmanager.IEventInterface;
import ElcRate.exception.InitializationException;
import ElcRate.exception.ProcessingException;
import ElcRate.logging.ILogger;
import ElcRate.logging.LogUtil;
import ElcRate.record.FlatRecord;
import ElcRate.record.HeaderRecord;
import ElcRate.record.IRecord;
import ElcRate.utils.PropertyUtils;
import eonerate.hotexport.entity.RateRecord;

/**
 * 
 * @author manucian86
 *
 */
public abstract class MyFlatFileOutputAdapter extends
		AbstractTransactionalOutputAdapter implements IEventInterface {

	ILogger LOG_PROCESSING = LogUtil.getLogUtil().getLogger("Processing");

	// !!!
	private static final long DEFAULT_HEADER_ID = 0;

	/**
	 * doing CDR file path
	 */
	private String proOutputFileName = null;
	/**
	 * CDR file path
	 */
	private String outputFileName = null;

	private boolean existedDoingCdrFile = false;

	// FILE NAME
	/**
	 * File sequence, gia tri duoc ghi tren CDR file name
	 */
	private long headerId = 1;

	// ----------------------------------------------------------------------

	// The buffer size is the size of the buffer in the buffered reader
	private static final int BUF_SIZE = 65536;

	// File writers
	private BufferedWriter validWriter;
	private BufferedWriter errorWriter;

	// If we are using a single writer
	private boolean singleWriter = false;

	private String filePath;
	private String filePrefix;
	private String fileSuffix;
	private String errPath;
	private String errPrefix;
	private String errSuffix;
	private boolean delEmptyOutFile = false;
	private boolean delEmptyErrFile = true;

	// This is the prefix that will be added during processing
	private String processingPrefix;

	// This tells us if we should look for a file to open
	// or continue reading from the one we have
	private boolean outputStreamOpen = false;

	// This is the base name of the file we are outputting
	private String fileBaseName = null;

	// List of Services that this Client supports
	private final static String SERVICE_FILE_PATH = "OutputFilePath";
	private final static String SERVICE_FILE_PREFIX = "OutputFilePrefix";
	private final static String SERVICE_FILE_SUFFIX = "OutputFileSuffix";
	private final static String SERVICE_DEL_EMPTY_OUT_FILE = "DeleteEmptyOutputFile";
	private final static String SERVICE_SINGLE_OUTPUT = "SingleOutputFile";
	private final static String SERVICE_ERR_PATH = "ErrFilePath";
	private final static String SERVICE_ERR_PREFIX = "ErrFilePrefix";
	private final static String SERVICE_ERR_SUFFIX = "ErrFileSuffix";
	private final static String SERVICE_DEL_EMPTY_ERR_FILE = "DeleteEmptyErrorFile";
	private static final String SERVICE_PROCPREFIX = "ProcessingPrefix";
	private static final String DEFAULT_PROCPREFIX = "tmp";

	// final static String SERVICE_OUT_FILE_NAME = "outputFileName";
	// final static String SERVICE_ERR_FILE_NAME = "ErrFileName";

	// This is used to hold the calculated file names
	public class TransControlStructure {
		String outputFileName;
		String errorFileName;
		String procOutputFileName;
		String procErrorFileName;
	}

	// This holds the file names for the files that are in processing at any
	// given moment
	private HashMap<Integer, TransControlStructure> CurrentFileNames;

	/**
	 * Default Constructor.
	 */
	public MyFlatFileOutputAdapter() {
		super();

		this.validWriter = null;
		this.errorWriter = null;
	}

	/**
	 * Gets the buffered file writer for valid records.
	 *
	 * @return The writer for valid records
	 */
	public BufferedWriter getValidWriter() {
		return validWriter;
	}

	/**
	 * Gets the buffered file writer for error records.
	 *
	 * @return The writer for valid records
	 */
	public BufferedWriter getErrorWriter() {
		if (singleWriter) {
			return validWriter;
		} else {
			return errorWriter;
		}
	}

	/**
	 * Initialize the output adapter with the configuration that is to be used
	 * for this instance of the adapter.
	 *
	 * @param PipelineName
	 *            The name of the pipeline this module is in
	 * @param ModuleName
	 *            The module symbolic name of this module
	 * @throws ElcRate.exception.InitializationException
	 */
	@Override
	public void init(String PipelineName, String ModuleName)
			throws InitializationException {
		String configHelper;

		super.init(PipelineName, ModuleName);

		configHelper = initGetFilePath();
		processControlEvent(SERVICE_FILE_PATH, true, configHelper);
		configHelper = initGetOutFilePrefix();
		processControlEvent(SERVICE_FILE_PREFIX, true, configHelper);
		configHelper = initGetOutFileSuffix();
		processControlEvent(SERVICE_FILE_SUFFIX, true, configHelper);
		configHelper = initGetDelEmptyOutFile();
		processControlEvent(SERVICE_DEL_EMPTY_OUT_FILE, true, configHelper);
		configHelper = initGetSingleOutputFile();
		processControlEvent(SERVICE_SINGLE_OUTPUT, true, configHelper);
		if (singleWriter) {
			// Single writer defined
			message = "Using Single Output for Adapter <" + getSymbolicName()
					+ ">";
			getPipeLog().info(message);
		} else {
			configHelper = initGetErrFilePath();
			processControlEvent(SERVICE_ERR_PATH, true, configHelper);
			configHelper = initGetErrFilePrefix();
			processControlEvent(SERVICE_ERR_PREFIX, true, configHelper);
			configHelper = initGetErrFileSuffix();
			processControlEvent(SERVICE_ERR_SUFFIX, true, configHelper);
			configHelper = initGetDelEmptyErrFile();
			processControlEvent(SERVICE_DEL_EMPTY_ERR_FILE, true, configHelper);
		}

		configHelper = initGetProcPrefix();
		processControlEvent(SERVICE_PROCPREFIX, true, configHelper);

		// Check the parameters we received
		initFileName();

		// create the structure for storing filenames
		CurrentFileNames = new HashMap<>(10);

		// !!!
		readHeaderId();
		checkExistDoingFile();
	}

	/**
	 * Process the stream header. Get the file base name and open the
	 * transaction.
	 *
	 * @param r
	 *            The record we are working on
	 * @return The processed record
	 * @throws ProcessingException
	 */
	@Override
	public IRecord procHeader(IRecord r) throws ProcessingException {
		HeaderRecord tmpHeader;
		int tmpTransNumber;
		TransControlStructure tmpFileNames = new TransControlStructure();

		tmpHeader = (HeaderRecord) r;

		super.procHeader(r);

		// if we are not currently streaming, open the stream using the transaction
		// information for the transaction we are processing
		if (!outputStreamOpen)
		{
			fileBaseName = tmpHeader.getStreamName();
			tmpTransNumber = tmpHeader.getTransactionNumber();

			// Calculate the names and open the writers
			tmpFileNames.procOutputFileName = filePath + System.getProperty("file.separator") +
					processingPrefix + filePrefix + fileBaseName + fileSuffix;
			tmpFileNames.outputFileName = filePath + System.getProperty("file.separator") +
					filePrefix + fileBaseName + fileSuffix;
			tmpFileNames.procErrorFileName = errPath + System.getProperty("file.separator") +
					processingPrefix + errPrefix + fileBaseName + errSuffix;
			tmpFileNames.errorFileName = errPath + System.getProperty("file.separator") +
					errPrefix + fileBaseName + errSuffix;

			// Store the names for later
			CurrentFileNames.put(tmpTransNumber, tmpFileNames);

			// !!!
			//			openValidFile(tmpFileNames.procOutputFileName);
			//			openErrFile(tmpFileNames.procErrorFileName);
			outputStreamOpen = true;
		}

		return r;
	}

	private String getHeaderIdFilePath() {
		return "configData/" + "headerid.txt";
	}

	/**
	 * Write good records to the defined output stream. This method performs
	 * record expansion (the opposite of record compression) and then calls the
	 * write for each of the records that results.
	 *
	 * @param r
	 *            The record we are working on
	 * @return The processed record
	 */
	@Override
	public IRecord prepValidRecord(IRecord r) throws ProcessingException {
		Collection<IRecord> outRecCol;
		FlatRecord outRec;
		Iterator<IRecord> outRecIter;

		outRecCol = procValidRecord(r);

		RateRecord tmpInRecord = (RateRecord) r;

		headerId = Long.parseLong(tmpInRecord.CDR_RECORD_HEADER_ID);

		if (!existedDoingCdrFile) {
			createDoingCdrFile();
		}

		PrintWriter out;
		try {
			out = new PrintWriter(getHeaderIdFilePath());

			out.println(headerId);

			out.flush();
			out.close();
		} catch (FileNotFoundException e) {
			this.getExceptionHandler().reportException(new ProcessingException(e, getSymbolicName()));
		}

		// Null return means "do not bother to process"
		if (outRecCol != null) {

			outRecIter = outRecCol.iterator();

			while (outRecIter.hasNext()) {
				IRecord tmp = outRecIter.next();

				outRec = (FlatRecord) tmp;

				try {

					// write the record to file
					File file = new File(proOutputFileName);
					FileWriter fwriter = new FileWriter(file, true);
					validWriter = new BufferedWriter(fwriter, BUF_SIZE);

					validWriter.write(outRec.getData());
					validWriter.newLine();
					validWriter.flush();
					validWriter.close();

				} catch (IOException ioex) {
					this.getExceptionHandler().reportException(new ProcessingException(ioex, getSymbolicName()));
				} catch (Exception ex) {
					this.getExceptionHandler().reportException(new ProcessingException(ex, getSymbolicName()));
				}
			}
		}

		return r;
	}

	@Override
	public void flushBlock() throws ProcessingException
	{
		if (getTransactionNumber() > 0) {
			File oldFile = new File(proOutputFileName);
			File newFile = new File(outputFileName);
			oldFile.renameTo(newFile);
			existedDoingCdrFile = false;
		}

		super.flushBlock();
	}

	private void checkExistDoingFile() {
		File directory = new File(filePath);

		File[] fList = directory.listFiles();
		for (File file : fList) {
			String name = file.getName();

			if (name.startsWith(filePrefix) && name.endsWith("." + headerId + processingPrefix)) {
				proOutputFileName = file.getAbsolutePath();
				outputFileName = proOutputFileName.substring(0, proOutputFileName.length() - processingPrefix.length());
				existedDoingCdrFile = true;

				break;
			}
		}
	}

	private void readHeaderId() {
		try {
			File source = new File(getHeaderIdFilePath());

			if (!source.exists()) {
				PrintWriter out = new PrintWriter(new FileOutputStream(getHeaderIdFilePath()));
				out.println(DEFAULT_HEADER_ID);
				out.flush();
				out.close();

				headerId = DEFAULT_HEADER_ID;
			} else {
				Scanner scanner = new Scanner(source);
				headerId = scanner.nextLong();
				scanner.close();
			}

		} catch (Exception ex) {
			System.err.println("Couldn't init headerId with file: " + getHeaderIdFilePath());
			this.getExceptionHandler().reportException(new ProcessingException(ex, getSymbolicName()));
			System.exit(1);
		}
	}

	/**
	 * Tao ra file doing, ghi File header len file doing nay
	 */
	private void createDoingCdrFile() {

		outputFileName = filePath + System.getProperty("file.separator") +
				filePrefix + headerId + fileSuffix; // ".bill";
		proOutputFileName = filePath + System.getProperty("file.separator") +
				filePrefix + headerId + fileSuffix + processingPrefix;

		try {
			File file = new File(proOutputFileName);
			FileWriter fwriter = new FileWriter(file, true);
			validWriter = new BufferedWriter(fwriter, BUF_SIZE);

			validWriter.write(StringUtils.EMPTY);

			validWriter.flush();
			validWriter.close();

			existedDoingCdrFile = true;
		} catch (IOException e) {
			this.getExceptionHandler().reportException(new ProcessingException(e, getSymbolicName()));
		}
	}

	/**
	 * Write bad records to the defined output stream.
	 *
	 * @param r
	 *            The record we are working on
	 * @return The processed record
	 */
	@Override
	public IRecord prepErrorRecord(IRecord r) throws ProcessingException {
		Collection<IRecord> outRecCol;
		FlatRecord outRec;
		Iterator<IRecord> outRecIter;

		outRecCol = procErrorRecord(r);

		// Null return means "do not bother to process"
		if (outRecCol != null) {
			outRecIter = outRecCol.iterator();

			while (outRecIter.hasNext()) {
				outRec = (FlatRecord) outRecIter.next();

				try {
					errorWriter.write(outRec.getData());
					errorWriter.newLine();
				} catch (IOException ioex) {
					this.getExceptionHandler().reportException(
							new ProcessingException(ioex, getSymbolicName()));
				} catch (Exception ex) {
					this.getExceptionHandler().reportException(
							new ProcessingException(ex, getSymbolicName()));
				}
			}
		}

		return r;
	}

	/**
	 * Process the stream trailer. Get the file base name and open the
	 * transaction.
	 *
	 * @param r
	 *            The record we are working on
	 */
	@Override
	public IRecord procTrailer(IRecord r) {
		// Close the files
		closeFiles(getTransactionNumber());

		// Do the transaction level maintenance
		super.procTrailer(r);

		return r;
	}

	/**
	 * Open the output file for writing.
	 *
	 * @param filename
	 *            The name of the file to open
	 */
	public void openValidFile(String filename) {
		FileWriter fwriter = null;
		File file;
		file = new File(filename);

		try {
			if (file.createNewFile() == false) {
				getPipeLog().error("output file already exists = " + filename);
			}

			fwriter = new FileWriter(file);
		} catch (IOException ex) {
			getPipeLog().error(
					"Error opening valid stream output for file " + filename);
		}

		validWriter = new BufferedWriter(fwriter, BUF_SIZE);
	}

	/**
	 * Open the output file for writing error records
	 *
	 * @param filename
	 *            The name of the file to open
	 */
	public void openErrFile(String filename) {
		FileWriter fwriter = null;
		File file;
		file = new File(filename);

		if (singleWriter) {
			errorWriter = validWriter;
		} else {
			try {
				if (file.createNewFile() == false) {
					getPipeLog().error(
							"output file already exists = " + filename);
				}

				fwriter = new FileWriter(file);
			} catch (IOException ex) {
				getPipeLog().error(
						"Error opening error stream output for file "
								+ filename);
			}

			errorWriter = new BufferedWriter(fwriter);
		}
	}

	@Override
	public void closeStream(int transactionNumber) {
		// Nothing for the moment
	}

	/**
	 * Close the files now that writing has been concluded.
	 *
	 * @param transactionNumber
	 *            The transaction number we are working on
	 * @return 0 if the file closing went OK
	 */
	public int closeFiles(int transactionNumber) {
		boolean ErrorFound = false;
		int ReturnCode = 0;

		if (outputStreamOpen) {
			try {
				if (validWriter != null) {
					validWriter.close();
				}
			} catch (IOException ioe) {
				getPipeLog().error("Error closing output file", ioe);
				ErrorFound = true;
			}

			// We don't need to close if we are using a single writer
			if (singleWriter == false) {
				try {
					if (errorWriter != null) {
						errorWriter.close();
					}
				} catch (IOException ioe) {
					getPipeLog().error("Error closing output file", ioe);
					ErrorFound = true;
				}
			}

			outputStreamOpen = false;

			if (ErrorFound) {
				ReturnCode = 1;
			} else {
				ReturnCode = 0;
			}
		}

		return ReturnCode;
	}

	/**
	 * Close the files now that writing has been concluded.
	 *
	 * @param transactionNumber
	 *            The transaction number we are working on
	 */
	public void closeTransactionOK(int transactionNumber) {
		File f;

		// rename the valid file
		f = new File(getProcOutputName(transactionNumber));
		if (delEmptyOutFile && getOutputFileEmpty(transactionNumber))
		{
			// Delete the empty file
			getPipeLog().debug("Deleted empty valid output file <" + getProcOutputName(transactionNumber) + ">");
			f.delete();
		}
		else
		{
			// Rename the file
			f.renameTo(new File(getOutputName(transactionNumber)));
		}

		// rename the error file
		// We don't need to rename if we are using a single writer
		if (singleWriter == false)
		{
			f = new File(getProcErrorName(transactionNumber));
			if (delEmptyErrFile && getErrorFileEmpty(transactionNumber))
			{
				// Delete the empty file
				getPipeLog().debug("Deleted empty error output file <" + getProcErrorName(transactionNumber) + ">");
				f.delete();
			}
			else
			{
				// Rename the file
				f.renameTo(new File(getErrorName(transactionNumber)));
			}
		}
	}

	/**
	 * Close the files now that writing has been concluded.
	 *
	 * @param transactionNumber
	 *            The transaction number we are working on
	 */
	public void closeTransactionErr(int transactionNumber) {
		File f;

		// rename the file
		f = new File(getProcOutputName(transactionNumber));
		f.delete();

		// delete the error file
		if (singleWriter == false) {
			// rename the file
			f = new File(getProcErrorName(transactionNumber));
			f.delete();
		}
	}

	// -----------------------------------------------------------------------------
	// --------------- Start of custom implementation functions
	// --------------------
	// -----------------------------------------------------------------------------

	/**
	 * Checks if the valid output file is empty. This method is intended to be
	 * overwritten in the case that you wish to modify the behaviour of the
	 * output file deletion.
	 *
	 * The default behaviour is that we check to see if any bytes have been
	 * written to the output file, but sometimes this is not the right way, for
	 * example if a file has a header/trailer but no detail records.
	 *
	 * @param transactionNumber
	 *            The number of the transaction to check for
	 * @return true if the file is empty, otherwise false
	 */
	public boolean getOutputFileEmpty(int transactionNumber) {
		File f = new File(getProcOutputName(transactionNumber));
		if (f.length() == 0) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Checks if the error output file is empty. This method is intended to be
	 * overwritten in the case that you wish to modify the behaviour of the
	 * output file deletion.
	 *
	 * The default behaviour is that we check to see if any bytes have been
	 * written to the output file, but sometimes this is not the right way, for
	 * example if a file has a header/trailer but no detail records.
	 *
	 * Note that this method is not called if the "single output file mode" has
	 * been selected by not defining an error output file in the output adapter.
	 *
	 * @param transactionNumber
	 *            The number of the transaction to check for
	 * @return true if the file is empty, otherwise false
	 */
	public boolean getErrorFileEmpty(int transactionNumber) {
		File f = new File(getProcErrorName(transactionNumber));
		if (f.length() == 0) {
			return true;
		} else {
			return false;
		}
	}

	// -----------------------------------------------------------------------------
	// --------------- Start of transactional layer functions
	// ----------------------
	// -----------------------------------------------------------------------------

	/**
	 * When a transaction is started, the transactional layer calls this method
	 * to see if we have any reason to stop the transaction being started, and
	 * to do any preparation work that may be necessary before we start.
	 *
	 * @param transactionNumber
	 *            The transaction number we are working on
	 * @return 0 if the transaction can start
	 */
	@Override
	public int startTransaction(int transactionNumber) {
		// We do not have any reason to inhibit the transaction start, so return
		// the OK flag
		return 0;
	}

	/**
	 * Perform any processing that needs to be done when we are flushing the
	 * transaction
	 *
	 * @param transactionNumber
	 *            The transaction number we are working on
	 * @return 0 if the transaction was flushed OK
	 */
	@Override
	public int flushTransaction(int transactionNumber) {
		// close the input stream
		return 0;
	}

	/**
	 * Perform any processing that needs to be done when we are committing the
	 * transaction
	 *
	 * @param transactionNumber
	 *            The transaction number we are working on
	 */
	@Override
	public void commitTransaction(int transactionNumber) {
		closeTransactionOK(transactionNumber);
	}

	/**
	 * Perform any processing that needs to be done when we are rolling back the
	 * transaction
	 *
	 * @param transactionNumber
	 *            The transaction number we are working on
	 */
	@Override
	public void rollbackTransaction(int transactionNumber) {
		closeTransactionErr(transactionNumber);
	}

	/**
	 * Close Transaction is the trigger to clean up transaction related
	 * information such as variables, status etc.
	 *
	 * @param transactionNumber
	 *            The transaction we are working on
	 */
	@Override
	public void closeTransaction(int transactionNumber) {
		// Clean up the file names
		CurrentFileNames.remove(transactionNumber);
	}

	// -----------------------------------------------------------------------------
	// ------------- Start of inherited IEventInterface functions
	// ------------------
	// -----------------------------------------------------------------------------

	/**
	 * processControlEvent is the event processing hook for the External Control
	 * Interface (ECI). This allows interaction with the external world.
	 *
	 * @param command
	 *            The command that we are to work on
	 * @param init
	 *            True if the pipeline is currently being constructed
	 * @param parameter
	 *            The parameter value for the command
	 * @return The result message of the operation
	 */
	@Override
	public String processControlEvent(String command, boolean init,
			String parameter) {
		int ResultCode = -1;

		if (command.equalsIgnoreCase(SERVICE_FILE_PATH)) {
			if (init) {
				filePath = parameter;
				ResultCode = 0;
			} else {
				if (parameter.equals("")) {
					return filePath;
				} else {
					return CommonConfig.NON_DYNAMIC_PARAM;
				}
			}
		}

		if (command.equalsIgnoreCase(SERVICE_FILE_PREFIX)) {
			if (init) {
				filePrefix = parameter;
				ResultCode = 0;
			} else {
				if (parameter.equals("")) {
					return filePrefix;
				} else {
					return CommonConfig.NON_DYNAMIC_PARAM;
				}
			}
		}

		if (command.equalsIgnoreCase(SERVICE_FILE_SUFFIX)) {
			if (init) {
				fileSuffix = parameter;
				ResultCode = 0;
			} else {
				if (parameter.equals("")) {
					return fileSuffix;
				} else {
					return CommonConfig.NON_DYNAMIC_PARAM;
				}
			}
		}

		if (command.equalsIgnoreCase(SERVICE_SINGLE_OUTPUT)) {
			if (init) {
				singleWriter = Boolean.parseBoolean(parameter);
				ResultCode = 0;
			} else {
				if (parameter.equals("")) {
					return Boolean.toString(singleWriter);
				} else {
					return CommonConfig.NON_DYNAMIC_PARAM;
				}
			}
		}

		if (command.equalsIgnoreCase(SERVICE_ERR_PATH)) {
			if (init) {
				errPath = parameter;
				ResultCode = 0;
			} else {
				if (parameter.equals("")) {
					return errPath;
				} else {
					return CommonConfig.NON_DYNAMIC_PARAM;
				}
			}
		}

		if (command.equalsIgnoreCase(SERVICE_ERR_PREFIX)) {
			if (init) {
				errPrefix = parameter;
				ResultCode = 0;
			} else {
				if (parameter.equals("")) {
					return errPrefix;
				} else {
					return CommonConfig.NON_DYNAMIC_PARAM;
				}
			}
		}

		if (command.equalsIgnoreCase(SERVICE_ERR_SUFFIX)) {
			if (init) {
				errSuffix = parameter;
				ResultCode = 0;
			} else {
				if (parameter.equals("")) {
					return errSuffix;
				} else {
					return CommonConfig.NON_DYNAMIC_PARAM;
				}
			}
		}

		if (command.equalsIgnoreCase(SERVICE_DEL_EMPTY_OUT_FILE)) {
			if (init) {
				if (parameter != null) {
					if (parameter.equalsIgnoreCase("true")) {
						delEmptyOutFile = true;
						ResultCode = 0;
					}

					if (parameter.equalsIgnoreCase("false")) {
						delEmptyOutFile = false;
						ResultCode = 0;
					}
				}
			} else {
				if (parameter.equals("")) {
					if (delEmptyOutFile) {
						return "true";
					} else {
						return "false";
					}
				} else {
					return CommonConfig.NON_DYNAMIC_PARAM;
				}
			}
		}

		if (command.equalsIgnoreCase(SERVICE_DEL_EMPTY_ERR_FILE)) {
			if (init) {
				if (parameter != null) {
					if (parameter.equalsIgnoreCase("true")) {
						delEmptyErrFile = true;
						ResultCode = 0;
					}

					if (parameter.equalsIgnoreCase("false")) {
						delEmptyErrFile = false;
						ResultCode = 0;
					}
				}
			} else {
				if (parameter != null) {
					if (parameter.equals("")) {
						if (delEmptyErrFile) {
							return "true";
						} else {
							return "false";
						}
					} else {
						return CommonConfig.NON_DYNAMIC_PARAM;
					}
				}
			}
		}

		if (command.equalsIgnoreCase(SERVICE_PROCPREFIX)) {
			if (init) {
				processingPrefix = parameter;
				ResultCode = 0;
			} else {
				if (parameter != null) {
					if (parameter.equals("")) {
						return processingPrefix;
					} else {
						return CommonConfig.NON_DYNAMIC_PARAM;
					}
				}
			}
		}

		if (ResultCode == 0) {
			getPipeLog().debug(
					LogUtil.LogECIPipeCommand(getSymbolicName(), getPipeName(),
							command, parameter));

			return "OK";
		} else {
			// This is not our event, pass it up the stack
			return super.processControlEvent(command, init, parameter);
		}
	}

	/**
	 * registerClientManager registers this class as a client of the ECI
	 * listener and publishes the commands that the plug in understands. The
	 * listener is responsible for delivering only these commands to the plug
	 * in.
	 *
	 */
	@Override
	public void registerClientManager() throws InitializationException {
		// Set the client reference and the base services first
		super.registerClientManager();

		//Register services for this Client
		ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_FILE_PATH, ClientManager.PARAM_NONE);
		ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_FILE_PREFIX, ClientManager.PARAM_NONE);
		ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_FILE_SUFFIX, ClientManager.PARAM_NONE);
		ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_SINGLE_OUTPUT, ClientManager.PARAM_NONE);
		ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_ERR_PATH, ClientManager.PARAM_NONE);
		ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_ERR_PREFIX, ClientManager.PARAM_NONE);
		ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_ERR_SUFFIX, ClientManager.PARAM_NONE);
		ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_DEL_EMPTY_OUT_FILE, ClientManager.PARAM_NONE);
		ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_DEL_EMPTY_ERR_FILE, ClientManager.PARAM_NONE);
		ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_PROCPREFIX, ClientManager.PARAM_NONE);

		//ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_OUT_FILE_NAME, false, false);
		//ClientManager.getClientManager().registerClientService(getSymbolicName(), SERVICE_ERR_FILE_NAME, false, false);
	}

	// -----------------------------------------------------------------------------
	// -------------------- Start of initialisation functions
	// ----------------------
	// -----------------------------------------------------------------------------

	/**
	 * Temporary function to gather the information from the properties file.
	 * Will be removed with the introduction of the new configuration model.
	 */
	private String initGetFilePath() throws InitializationException {
		String tmpFile;
		tmpFile = PropertyUtils.getPropertyUtils()
				.getBatchOutputAdapterPropertyValueDef(getPipeName(),
						getSymbolicName(), SERVICE_FILE_PATH, "");

		return tmpFile;
	}

	/**
	 * Temporary function to gather the information from the properties file.
	 * Will be removed with the introduction of the new configuration model.
	 */
	private String initGetOutFilePrefix() throws InitializationException {
		String tmpFile;

		tmpFile = PropertyUtils.getPropertyUtils()
				.getBatchOutputAdapterPropertyValueDef(getPipeName(),
						getSymbolicName(), SERVICE_FILE_PREFIX, "");

		return tmpFile;
	}

	/**
	 * Temporary function to gather the information from the properties file.
	 * Will be removed with the introduction of the new configuration model.
	 */
	private String initGetOutFileSuffix() throws InitializationException {
		String tmpFile;
		tmpFile = PropertyUtils.getPropertyUtils()
				.getBatchOutputAdapterPropertyValueDef(getPipeName(),
						getSymbolicName(), SERVICE_FILE_SUFFIX, "");

		return tmpFile;
	}

	/**
	 * Temporary function to gather the information from the properties file.
	 * Will be removed with the introduction of the new configuration model.
	 */
	private String initGetSingleOutputFile() throws InitializationException {
		String tmpSetting;
		tmpSetting = PropertyUtils.getPropertyUtils()
				.getBatchOutputAdapterPropertyValueDef(getPipeName(),
						getSymbolicName(), SERVICE_SINGLE_OUTPUT, "False");

		return tmpSetting;
	}

	/**
	 * Temporary function to gather the information from the properties file.
	 * Will be removed with the introduction of the new configuration model.
	 */
	private String initGetErrFilePath() throws InitializationException {
		String tmpFile;
		tmpFile = PropertyUtils.getPropertyUtils()
				.getBatchOutputAdapterPropertyValueDef(getPipeName(),
						getSymbolicName(), SERVICE_ERR_PATH, "");

		return tmpFile;
	}

	/**
	 * Temporary function to gather the information from the properties file.
	 * Will be removed with the introduction of the new configuration model.
	 */
	private String initGetErrFilePrefix() throws InitializationException {
		String tmpFile;
		tmpFile = PropertyUtils.getPropertyUtils()
				.getBatchOutputAdapterPropertyValueDef(getPipeName(),
						getSymbolicName(), SERVICE_ERR_PREFIX, "");

		return tmpFile;
	}

	/**
	 * Temporary function to gather the information from the properties file.
	 * Will be removed with the introduction of the new configuration model.
	 */
	private String initGetErrFileSuffix() throws InitializationException {
		String tmpFile;
		tmpFile = PropertyUtils.getPropertyUtils()
				.getBatchOutputAdapterPropertyValueDef(getPipeName(),
						getSymbolicName(), SERVICE_ERR_SUFFIX, "");

		return tmpFile;
	}

	/**
	 * Temporary function to gather the information from the properties file.
	 * Will be removed with the introduction of the new configuration model.
	 */
	private String initGetDelEmptyOutFile() throws InitializationException {
		String tmpFile;
		tmpFile = PropertyUtils.getPropertyUtils()
				.getBatchOutputAdapterPropertyValueDef(getPipeName(),
						getSymbolicName(), SERVICE_DEL_EMPTY_OUT_FILE, "");

		return tmpFile;
	}

	/**
	 * Temporary function to gather the information from the properties file.
	 * Will be removed with the introduction of the new configuration model.
	 */
	private String initGetDelEmptyErrFile() throws InitializationException {
		String tmpFile;
		tmpFile = PropertyUtils.getPropertyUtils()
				.getBatchOutputAdapterPropertyValueDef(getPipeName(),
						getSymbolicName(), SERVICE_DEL_EMPTY_ERR_FILE, "");

		return tmpFile;
	}

	/**
	 * Temporary function to gather the information from the properties file.
	 * Will be removed with the introduction of the new configuration model.
	 */
	private String initGetProcPrefix() throws InitializationException {
		String tmpProcPrefix;
		tmpProcPrefix = PropertyUtils.getPropertyUtils()
				.getBatchOutputAdapterPropertyValueDef(getPipeName(),
						getSymbolicName(), SERVICE_PROCPREFIX,
						DEFAULT_PROCPREFIX);

		return tmpProcPrefix;
	}

	/**
	 * Checks the file name from the input parameters.
	 *
	 * The method checks for validity of the input parameters that have been
	 * configured, for example if the directory does not exist, an exception
	 * will be thrown.
	 */
	private void initFileName() throws InitializationException {
		File dir;

		if (filePath == null) {
			// The path has not been defined
			message = "Output Adapter <" + getSymbolicName()
					+ "> processed file path has not been defined";
			getPipeLog().fatal(message);
			throw new InitializationException(message, getSymbolicName());
		}

		// if it is defined, is it valid?
		dir = new File(filePath);
		if (!dir.isDirectory()) {
			message = "Output Adapter <" + getSymbolicName()
					+ "> used a processed file path <" + filePath
					+ ">that does not exist or is not a directory";
			getPipeLog().fatal(message);
			throw new InitializationException(message, getSymbolicName());
		}

		if (singleWriter == false) {
			// if it is defined, is it valid?
			dir = new File(errPath);
			if (!dir.isDirectory()) {
				message = "Output Adapter <" + getSymbolicName()
						+ "> used an error file path <" + errPath
						+ "> that does not exist or is not a directory";
				getPipeLog().fatal(message);
				throw new InitializationException(message, getSymbolicName());
			}
		}
	}

	/**
	 * Get the proc file name for the valid record output file for the given
	 * transaction
	 *
	 * @param transactionNumber
	 *            The number of the transaction to get the name for
	 * @return The processing output file name
	 */
	protected String getProcOutputName(int transactionNumber) {
		TransControlStructure tmpFileNames;

		// Get the name to work on
		tmpFileNames = CurrentFileNames.get(transactionNumber);

		return tmpFileNames.procOutputFileName;
	}

	/**
	 * Get the final output file name for the valid record output file for the
	 * given transaction
	 *
	 * @param transactionNumber
	 *            The number of the transaction to get the name for
	 * @return The final output file name
	 */
	protected String getOutputName(int transactionNumber) {
		TransControlStructure tmpFileNames;

		// Get the name to work on
		tmpFileNames = CurrentFileNames.get(transactionNumber);

		return tmpFileNames.outputFileName;
	}

	/**
	 * Get the proc file name for the error record output file for the given
	 * transaction
	 *
	 * @param transactionNumber
	 *            The number of the transaction to get the name for
	 * @return The processing error file name
	 */
	protected String getProcErrorName(int transactionNumber) {
		TransControlStructure tmpFileNames;

		// Get the name to work on
		tmpFileNames = CurrentFileNames.get(transactionNumber);

		return tmpFileNames.procErrorFileName;
	}

	/**
	 * Get the final output file name for the error record output file for the
	 * given transaction
	 *
	 * @param transactionNumber
	 *            The number of the transaction to get the name for
	 * @return The processing output file name
	 */
	protected String getErrorName(int transactionNumber) {
		TransControlStructure tmpFileNames;

		// Get the name to work on
		tmpFileNames = CurrentFileNames.get(transactionNumber);

		return tmpFileNames.errorFileName;
	}
}
