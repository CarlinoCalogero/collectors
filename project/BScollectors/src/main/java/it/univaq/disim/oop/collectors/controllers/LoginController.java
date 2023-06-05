package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;

public class LoginController<T> implements Initializable, DataInitalizable<T>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	
	@FXML
	private Button loginButton;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// TODO Auto-generated method stub
		
	}
	
	public void initializeData(T t) {
		
	}

	public void login() {
		dispatcher.renderVista("home", null);
	}
}
