package it.univaq.disim.oop.collectors.business.JBCD;

public class DatabaseConnectionException extends Exception {

	public DatabaseConnectionException() {
		super();
	}

	public DatabaseConnectionException(Exception e) {
		super(e);
	}

	public DatabaseConnectionException(String cause, Exception e) {
		super(cause, e);
	}
}
