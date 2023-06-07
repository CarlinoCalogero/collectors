package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.sql.SQLException;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;

public class LoginController<T> implements Initializable, DataInitalizable<T>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	@FXML
	private TextField nickname, email;
	@FXML
	private Button loginButton;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// TODO Auto-generated method stub
		
	}
	
	public void initializeData(T t) {
		
	}

	public void login() {
		try {
		Collector collector = implementation.login("Michael", "michael.piccirilli@student.univaq.it");
		if(collector == null) throw new DatabaseConnectionException("Wrong nickname or email!");
		dispatcher.renderHome(collector);
		} catch (DatabaseConnectionException e) {
			System.err.println(e.getMessage());
		}
	}
}
