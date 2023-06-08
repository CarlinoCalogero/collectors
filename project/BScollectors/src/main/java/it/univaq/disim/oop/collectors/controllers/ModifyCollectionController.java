package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;
import java.util.stream.Collectors;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Couple;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.cell.PropertyValueFactory;

public class ModifyCollectionController implements Initializable, DataInitalizable<Couple<Collector,Collection>>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	private Collection collection;
	private Collector collector;
	
	private ObservableList<Collector> collectorsData;
	private ObservableList<Collector> sharingCollector;
	
	@FXML
	private TableView<Collector> condivisioneTableView;
	
	@FXML
	private TableColumn<Collector,String> collezionistaTableColumn;
	
	@FXML
	private TableColumn<Collector,Button> condividiTableColumn;
	
	@FXML
	private Button saveButton, inserisciDisco;
	
	@FXML
	private TextField nameTextField;
	
	@FXML
	private RadioButton publicRadioButton, privateRadioButton;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		collezionistaTableColumn.setCellValueFactory(new PropertyValueFactory<Collector, String>("nickname"));
		condividiTableColumn.setStyle("-fx-alignment: CENTER;");
		condividiTableColumn.setCellValueFactory((CellDataFeatures<Collector, Button> param) -> {
			final Button condividiButton;
			if(sharingCollector.contains(param.getValue())) {
				condividiButton = new Button("Rimuovi");
			} else {
				condividiButton = new Button("Condividi");
			} 
			condividiButton.setOnAction((ActionEvent event) -> {
				try {
					if(condividiButton.getText().equals("Condividi")) {
						implementation.insertCondivisione(collection.getID(), param.getValue());
						condividiButton.setText("Rimuovi");
					} else {
						//remove condivisione
					}
				} catch (DatabaseConnectionException e) {
					e.printStackTrace();
				}
			});
			return new SimpleObjectProperty<Button>(condividiButton);
		});
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
		
		try {
			
			//Per prendere i collezionisti con cui la collezione è già condivisa
			sharingCollector = FXCollections.observableArrayList(implementation.getSharingOf(collection));
			List<Collector> collectors = new ArrayList<>();
			if(!collection.getVisibilita()) {
				collectors = implementation.getCollectors();
			}
			
			//Rimuovo dalla lista delle condivisioni il proprietario della collezione
			collectors.remove(collector);
			
			collectorsData = FXCollections.observableArrayList(collectors);
			condivisioneTableView.setItems(collectorsData);
		} catch (DatabaseConnectionException e) {
			e.printStackTrace();
		}
	}
	
	@FXML
	private void goToInserimentoDisco() {
		dispatcher.renderView("insert_disco", collection);
	}
	@FXML
	private void save() throws DatabaseConnectionException {
		dispatcher.renderHome(collector);
	}
}
