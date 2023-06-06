package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextField;

public class InsertCollectionController<T> implements Initializable,DataInitalizable<T>{
	
	@FXML
	private Button saveButton;
	
	@FXML
	private TextField nameTextField;
	
	@FXML
	private RadioButton publicRadioButton, privateRadioButton;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		
	}
	
	public void initializeData(T t) {
		
	}
	
	@FXML
	private void save() {
		
	}

}
