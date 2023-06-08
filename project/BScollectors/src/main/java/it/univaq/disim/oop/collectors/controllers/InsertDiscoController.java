package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Disco;
import it.univaq.disim.oop.collectors.domain.Etichetta;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.DatePicker;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.TableView;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;

public class InsertDiscoController implements Initializable,DataInitalizable<Collection>{

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	private List<String> generi = new ArrayList<>();
	private Collection collection;

	@FXML
	private Button saveButton;
	
	@FXML
	private ComboBox<String> formatoComboBox,statoComboBox;
	
	@FXML
	private DatePicker dataPicker;
	
	@FXML
	private TableView<String> generiTableView;
	
	@FXML
	private TableColumn<String,String> genereTableColumn;
	
	@FXML
	private TableColumn<String,Button> aggiungiTableColumn;
	
	@FXML
	private TextArea noteTextArea;
	
	@FXML
	private TextField barcodeTextField, titoloTextField, etichettaTextField, numeroCopieTextField;
	
	@Override
	public void initialize(URL location, ResourceBundle resources) {
		statoComboBox.setItems(FXCollections.observableArrayList(implementation.getStates()));
		formatoComboBox.setItems(FXCollections.observableArrayList(implementation.getFormats()));
		
		genereTableColumn.setCellValueFactory((CellDataFeatures<String, String> param) -> {
			return new SimpleObjectProperty<String>(param.getValue());
		});
		aggiungiTableColumn.setCellValueFactory((CellDataFeatures<String, Button> param) -> {
			final Button aggiungiButton = new Button("Rimuovi");
			aggiungiButton.setOnAction((ActionEvent event) -> {
				generi.add(param.getValue());
			});
			return new SimpleObjectProperty<Button>(aggiungiButton);
		});
	}

	public void initializeData(Collection collection) {
		this.collection = collection;
	}
	
	@FXML
	private void save() throws DatabaseConnectionException {
		List<Etichetta> etichette = implementation.getEtichette();
		Etichetta etichetta = null;
		for(Etichetta e : etichette) {
			if(e.getNome().equals(etichettaTextField.getText())) {
				etichetta = e;
				break;
			}
		}
		
		Disco disco = new Disco(null, 
								titoloTextField.getText(), 
								dataPicker.getValue(), 
								statoComboBox.getValue(),
								formatoComboBox.getValue(),
								etichetta, 
								(String[])generi.toArray(), 
								barcodeTextField.getText(),
								noteTextArea.getText(),
								Integer.parseInt(numeroCopieTextField.getText()));
		implementation.aggiungiDiscoACollezione(disco, collection.getID());
		dispatcher.renderHome(null);
	}
}
