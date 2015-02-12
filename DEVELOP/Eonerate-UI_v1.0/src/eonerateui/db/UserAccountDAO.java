package eonerateui.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import org.apache.log4j.Logger;

import eonerateui.db.pool.DBConfig;
import eonerateui.db.pool.DBPool;
import eonerateui.entity.user.UserAccount;

public class UserAccountDAO {
	private static Logger logger=Logger.getLogger("UserAccountDAO");
	static int SUCCESS = 0;
	static int ERROR = -1;
	public static ArrayList<UserAccount> getListUserAccount() {
		ArrayList<UserAccount> searchResult = new ArrayList<UserAccount>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder query = new StringBuilder("");
		try{
			conn = getConnection();
			String schema = (new DBConfig()).getDb_schema();
			query.append("SELECT a.username , a.password, a.role, a.created_by, a.updated_time ");
			query.append("FROM " + schema + "user_account a ");	
			pstmt = conn.prepareStatement(query.toString());
			ResultSet rs = pstmt.executeQuery();
			while(rs.next()){
				  String username = rs.getString("username");
				  String password = rs.getString("password");
				  int role = rs.getInt("role");
				  String createdBy = rs.getString("created_by");
				  Date updateTime = rs.getDate("updated_time");
				  UserAccount userAccount = new UserAccount(username, password, role, createdBy, updateTime);
				  searchResult.add(userAccount);
			}
			pstmt.close();
			conn.close();
		}catch(Exception e){
			logger.error("Exception", e);
		}
		releaseConnection(conn, pstmt);
		return searchResult;
	}
	
	public static int createUser(UserAccount userAccount) {
		Connection conn = null;
		PreparedStatement stmt = null;
		StringBuilder query = new StringBuilder("");
		try{
			conn = getConnection();
			String schema = (new DBConfig()).getDb_schema();
			query.append("INSERT INTO " + schema + "USER_ACCOUNT(username, password, role, created_by) ");
			query.append("VALUES('" + userAccount.getUsername());
			query.append("','" + userAccount.getPassword());
			query.append("'," + userAccount.getRole());
			query.append(",'" + userAccount.getCreatedBy() + "')");
			stmt = conn.prepareStatement(query.toString());
			stmt.execute(query.toString());
			conn.commit();
			conn.close();
		}catch(Exception e){
			logger.error("Exception", e);
			return ERROR;
		}
		releaseConnection(conn, stmt);
		return SUCCESS;
	}
	
	public static int updatePassword(String username, String password){
		Connection conn = null;
		PreparedStatement stmt = null;
		StringBuilder query = new StringBuilder("");
		try{
			conn = getConnection();
			String schema = (new DBConfig()).getDb_schema();
			query.append("UPDATE " + schema + "USER_ACCOUNT ");
			query.append("SET password = '" + password + "' ");
			query.append("WHERE username = '" + username + "'");
			stmt = conn.prepareStatement(query.toString());
			stmt.execute(query.toString());
			conn.commit();
			conn.close();
		}catch(Exception e){
			logger.error("Exception: " + e.getMessage());
			return ERROR;
		}
		releaseConnection(conn, stmt);
		return SUCCESS;
	}
	
	public static Boolean checkExistUser(String username){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
		try{
			String schema = (new DBConfig()).getDb_schema();
			String query = "SELECT count(1) FROM " + schema + "user_account where username = '" + username + "'";
			conn = getConnection();
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery(query);
			rs.next();
			result = rs.getInt(1);
		}catch (Exception e) {
			logger.error("Exception: " + e.getMessage());
		}
		
		if(result > 0) return true;
		else return false;
	}
	
	public static int updatePasswordForUser(String username, String newPassword){
		Connection conn = null;
		PreparedStatement stmt = null;
		StringBuilder query = new StringBuilder("");
		try{
			conn = getConnection();
			String schema = (new DBConfig()).getDb_schema();
			query.append("UPDATE " + schema + "USER_ACCOUNT ");
			query.append("SET password = '" + newPassword + "' ");
			query.append("WHERE username = '" + username + "'");
			stmt = conn.prepareStatement(query.toString());
			stmt.execute(query.toString());
			conn.commit();
			conn.close();
		}catch(Exception e){
			logger.error("Exception: " + e.getMessage());
			return ERROR;
		}
		releaseConnection(conn, stmt);
		return SUCCESS;
	}
	
	public static int updateRoleForUser(UserAccount userAccount){
		Connection conn = null;
		PreparedStatement stmt = null;
		StringBuilder query = new StringBuilder("");
		try{
			conn = getConnection();
			String schema = (new DBConfig()).getDb_schema();
			query.append("UPDATE " + schema + "USER_ACCOUNT ");
			query.append("SET role = " + userAccount.getRole());
			query.append(" WHERE username = '" + userAccount.getUsername() + "'");
			stmt = conn.prepareStatement(query.toString());
			stmt.execute(query.toString());
			conn.commit();
			conn.close();
		}catch(Exception e){
			logger.error("Exception: " + e.getMessage());
			return ERROR;
		}
		releaseConnection(conn, stmt);
		return SUCCESS;
	}
	
	public static UserAccount getUserAccount(String username, String password){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder query = new StringBuilder("");
		UserAccount userAccount = new UserAccount();
		Integer role = 0;
		try{
			String schema = (new DBConfig()).getDb_schema();
			//String query = "SELECT count(1) FROM " + schema + "user_account where username = '" + username + "' and password = '" + password + "'";
			query.append("SELECT role ");
			query.append("FROM " + schema + "USER_ACCOUNT ");
			query.append("WHERE username = '" + username + "' ");
			query.append("AND password = '" + password + "' ");
			query.append("AND rownum <= 1");
			conn = getConnection();
			pstmt = conn.prepareStatement(query.toString());
			rs = pstmt.executeQuery(query.toString());
			while(rs.next()){
				role = rs.getInt("role");
			}
			
		}catch (Exception e) {
			role = -1;
			logger.error(query.toString());
			e.printStackTrace();
			logger.error("Exception: " + e.getMessage());
		}
		if(role > 0){
			userAccount.setUsername(username);
			userAccount.setRole(role);
		}
		return userAccount;
	}
	
	public static int deleteUser(UserAccount userAccount){
		Connection conn = null;
		PreparedStatement stmt = null;
		StringBuilder query = new StringBuilder("");
		try{
			conn = getConnection();
			String schema = (new DBConfig()).getDb_schema();
			query.append("DELETE FROM " + schema + "USER_ACCOUNT ");
			query.append(" WHERE username = '" + userAccount.getUsername() + "'");
			stmt = conn.prepareStatement(query.toString());
			stmt.execute(query.toString());
			conn.commit();
			conn.close();
		}catch(Exception e){
			logger.error("Exception: " + e.getMessage());
			return ERROR;
		}
		releaseConnection(conn, stmt);
		return SUCCESS;
	}
	
	
	public static Connection getConnection() throws SQLException {
		return DBPool.getConnection();
	}
	public static void releaseConnection(Connection conn, PreparedStatement preStmt) {
		DBPool.releaseConnection(conn, preStmt);
	}
	
	public static int updateAllUser(ArrayList<UserAccount> listUserAccount) {
		int result = SUCCESS;
		for(UserAccount userAccount : listUserAccount){
			result = updateRoleForUser(userAccount);
		}
		return result;
	}
}
