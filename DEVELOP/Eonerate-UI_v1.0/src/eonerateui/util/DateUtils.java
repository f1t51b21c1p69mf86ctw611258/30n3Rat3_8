package eonerateui.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import org.apache.commons.lang3.math.NumberUtils;

public class DateUtils {

	public static final String MMddyyyyHHmmss_FULL_SLASH = "MM/dd/yyyy HH:mm:ss";
	public static final String yyyyMMddHHmmss_NO_SLASH = "yyyy-MM-dd HH:mm:ss";
	public static final String yyyy_MM_dd_HHmmss_sss = "yyyy-MM-dd HH:mm:ss.sss";
	public static final String mmddYYYY_FULL_SLASH = "MM/dd/yyyy";
	public static final String mmddYY_NO_SLASH ="MM-dd-yy";
	public static final String hhmmss_sss = "hh:mm:ss";
	public static final String hhmmss = "hh:mm:ss";
	public static final String dd_MM_yyhhmmss = "dd-MM-yy HH:mm:ss";
	public static final String ddMMyyHHmmss_FULL_SLASH = "dd/MM/yy HH:mm:ss";
	
	
	public static String getCurrentDateTime(String format){
		
		try{
			DateFormat dateFormat = new SimpleDateFormat(format);
			Date date = new Date();
			return dateFormat.format(date).toString();	
		
		}catch (Exception e) {
			return "";
		}		
	}
	

	public static String getDateStringInformat(Date dateInput, String format){
		try{
			DateFormat dateFormat = new SimpleDateFormat(format);
			return dateFormat.format(dateInput).toString();	
		}catch (Exception e) {
			return "";
		}	
	}

  /**
   * 
   * @param format
   * @param String timeInCdr
   * 
   * 
   * @return timeInCdr in input format
   */
	
  public static String convert(String format, String timeInCdr){
	  try{
		    SimpleDateFormat dfInput = new SimpleDateFormat(format);
			Calendar calendar = Calendar.getInstance();
			calendar.setTimeInMillis(NumberUtils.toLong(timeInCdr + "000"));
			return dfInput.format(calendar.getTime());
	  }catch(Exception e){
		return "";
	  }
  }
  
  /**
   * 
   * @param format
   * @param long timeInCdr
   * 
   * 
   * @return timeInCdr in input format
   */
  public static String convert(String format, long timeSecond){
	  try{
		    SimpleDateFormat dfInput = new SimpleDateFormat(format);
			Calendar calendar = Calendar.getInstance();
			calendar.setTimeInMillis(timeSecond * 1000);
			return dfInput.format(calendar.getTime());
	  }catch(Exception e){
		return "";
	  }
  }
  
  
  /**
   * 
   * @param inputFormat
   * @param outputFormat
   * @param dateString
   * 
   * 
   * @return dateString in output fomat
   */
  
  public static String convertDate(String inputFormat, String outputFormat, String dateString){
	String format = "MM-dd-yy";
	DateFormat inputDF  = new SimpleDateFormat(format);
	DateFormat outputDF = new SimpleDateFormat("MM/dd/yyyy");
	try{
		Date date = inputDF.parse(dateString);
		String output = outputDF.format(date);
		return output;
	} catch(Exception e){
		e.printStackTrace();
		return "invalid format";
	}
  }
  
  public static long getDateLongValue(Date inputDate){
	  if(inputDate != null){
		  return inputDate.getTime() / 1000;  
	  }else{
		  return 0;
	  }
  }
  
  public static String minusDate(String time1, String time2) throws ParseException{
	  //10-23-13 10:50:48.0
	  SimpleDateFormat sf = new SimpleDateFormat(dd_MM_yyhhmmss);  
	  Date sDt1 = sf.parse(time1);  
	  Date sDt2 = sf.parse(time2);  
	  long ld1 = sDt1.getTime() /1000;  
	  long ld2 = sDt2.getTime() /1000; 
	  return (new Integer((int) (ld1-ld2))).toString();
  }
  
  public static void main(String args[]) throws InterruptedException, ParseException{
	  String time1 = "10-23-15 11:51:48";
	  String time2 = "10-23-15 10:50:40";
	  System.out.println(minusDate(time1, time2));
  }
  
}
