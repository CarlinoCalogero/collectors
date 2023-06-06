package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Couple;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextField;

public class ModifyCollectionController implements Initializable, DataInitalizable<Couple<Collector,Collection>>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	private Collection collection;
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
	
	public void initializeData(Couple<Collector,Collection> couple) {
		this.collection = couple.getSecond();
		this.collector = couple.getFirst();
		
		publicRadioButton.setOnMousePressed(event -> {
			if(collection.getVisibilita() == false) {
				try {
					implementation.switchVisibilita(collection.getID());
				} catch (DatabaseConnectionException e) {
					e.printStackTrace();
				}
			}
		});
		
		privateRadioButton.setOnMousePressed(event -> {
			if(collection.getVisibilita() == true) {
				try {
					implementation.switchVisibilita(collection.getID());
				} catch (DatabaseConnectionException e) {
					e.printStackTrace();
				}
			}
		});
	}
	
	@FXML
	private void save() throws DatabaseConnectionException {
		dispatcher.renderHome(collector);
	}
}
