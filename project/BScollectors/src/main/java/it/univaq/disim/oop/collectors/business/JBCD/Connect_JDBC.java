package it.univaq.disim.oop.collectors.business.JBCD;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connect_JDBC {
	private Connection connection;
	private final String password;
	private final String username;
	private final String connection_string;

	public Connect_JDBC(String connection_string, String username, String password) {
		this.password = password;
		this.username = username;
		this.connection_string = connection_string;
		this.connection = null;
	}

	// creiamo e restituiamo una singola connessione locale (singleton)
	// (che potrà essere chiusa da questo modulo)
	public Connection getConnection() throws DatabaseConnectionException {
		if (connection == null) {
			connection = connect();
		}
		return connection;
	}

	// questo metodo restituisce una nuova connessione a ogni chiamata
	// (che andrà chiusa dal ricevente!)
	public Connection newConnection() throws DatabaseConnectionException {
		return connect();
	}

	// connessione al database
	private Connection connect() throws DatabaseConnectionException {
		System.out.println("\n**** APERTURA CONNESSIONE ***************************");
		try {
			// connessione al database
			if (username != null && password != null) {
				this.connection = DriverManager.getConnection(connection_string, username, password);
			} else {
				this.connection = DriverManager.getConnection(connection_string);
			}
			return this.connection;
		} catch (SQLException ex) {
			// Usiamo un'eccezione user-defined per trasportare e gestire più
			// agevolmente tutte le eccezioni lagate all'uso del database
			throw new DatabaseConnectionException("Errore di connessione", ex);
		}
	}

	// disconnessione della connessione locale (singleton) se presente
	public void disconnect() throws DatabaseConnectionException {
		try {
			if (this.connection != null && !this.connection.isClosed()) {
				System.out.println("\n**** CHIUSURA CONNESSIONE (modulo connect) **********");
				this.connection.close();
			}
		} catch (SQLException ex) {
			throw new DatabaseConnectionException("Errore di disconnessione", ex);
		}
	}
}
