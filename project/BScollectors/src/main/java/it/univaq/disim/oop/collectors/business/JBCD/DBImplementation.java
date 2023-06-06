package it.univaq.disim.oop.collectors.business.JBCD;

public class DBImplementation {
	// Connection parameters needed
	private static final String DB_NAME = "collectors";
	private static final String PASSWORD = "$app!";
	private static final String APP_USERNAME = "application";
	
	private static final String CONNECTION = "jdbc:mysql://localhost:3306/" + DB_NAME+ "?serverTimezone=Europe/Rome";
	private Connect_JDBC connection = new Connect_JDBC(CONNECTION, APP_USERNAME, PASSWORD);
	private Query_JDBC queryModule;
	
	public DBImplementation(){
		try {
			queryModule = new Query_JDBC(connection.getConnection());
		} catch (DatabaseConnectionException e) {
			System.exit(0);
			e.printStackTrace();
		}
	}
	public Query_JDBC getImplementation() {
		return queryModule;
	}
}
