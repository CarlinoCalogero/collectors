package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextField;

public class InsertCollectionController implements Initializable,DataInitalizable<Collector>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	private Collector collector;
	
	@FXML
	private Button saveButton;
	
	@FXML
	private TextField nameTextField;
	
	@FXML
	private RadioButton publicRadioButton, privateRadioButton;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		
	}
	
	public void initializeData(Collector collector) {
		this.collector = collector;
	}
	
	@FXML
	private void save() throws DatabaseConnectionException {
		if(publicRadioButton.isSelected()) {
			implementation.insertCollezione(new Collection(null,nameTextField.getText(),true,collector.getID()));
		} else if (privateRadioButton.isSelected()) {
			
		} else System.err.println("La visibilità deve essere selezionata!");
	}

}
