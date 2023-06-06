package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

import org.controlsfx.control.SearchableComboBox;

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
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.HBox;

public class HomeController implements Initializable, DataInitalizable<Collector>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	private Collector collector;
	private ObservableList<Collection> collectionsData;
	
	@FXML
	private HBox parentHBox;
	
	@FXML
	private Button logoutButton;
	
	@FXML
	private Button inserisciCollezioneButton;
	
	@FXML
	private Label benvenutoLabel;
	
	@FXML
	private TextField searchTextField;
	
	@FXML
	private TableView<Collection> collectionsTableView;
	
	@FXML
	private TableColumn<Collection, String> nameTableColumn;
	
	@FXML
	private TableColumn<Collection, Boolean>visibilityTableColumn;
	
	@FXML
	private TableColumn<Collection, Button> seeTableColumn;
	
	@FXML
	private TableColumn<Collection, Button> modifyTableColumn;
	
	@FXML
	private TableColumn<Collection, Button> deleteTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
				
		nameTableColumn.setCellValueFactory(new PropertyValueFactory<Collection, String>("nome"));
		visibilityTableColumn.setStyle("-fx-alignment: CENTER;");
		visibilityTableColumn.setCellValueFactory(new PropertyValueFactory<Collection, Boolean>("visibilita"));
		seeTableColumn.setStyle("-fx-alignment: CENTER;");
		seeTableColumn.setCellValueFactory((CellDataFeatures<Collection, Button> param) -> {
			final Button modifyButton = new Button("Visualizza");
			modifyButton.setOnAction((ActionEvent event) -> {
				System.out.println("Visualizzando...");
			});
			return new SimpleObjectProperty<Button>(modifyButton);
		});
		deleteTableColumn.setStyle("-fx-alignment: CENTER;");
		deleteTableColumn.setCellValueFactory((CellDataFeatures<Collection, Button> param) -> {
			final Button modifyButton = new Button("Cancella");
			modifyButton.setOnAction((ActionEvent event) -> {
				try {
					implementation.deleteCollezione(param.getValue().getID());
					collectionsData.remove(param.getValue());
				} catch (DatabaseConnectionException e) {
					e.printStackTrace();
				}
			});
			return new SimpleObjectProperty<Button>(modifyButton);
		});
		modifyTableColumn.setStyle("-fx-alignment: CENTER;");
		modifyTableColumn.setCellValueFactory((CellDataFeatures<Collection, Button> param) -> {
			final Button modifyButton = new Button("Modifica");
			modifyButton.setOnAction((ActionEvent event) -> {
				dispatcher.renderView("modify_collection", new Couple<Collector, Collection>(collector, param.getValue()));
			});
			return new SimpleObjectProperty<Button>(modifyButton);
		});
	}
	
	public void initializeData(Collector collector) {
		benvenutoLabel.setText("Benvenuto "+collector.getNickname());
		this.collector = collector;
		try {
			List<Collection> collections = implementation.getCollections(collector.getID());
			collectionsData = FXCollections.observableArrayList(collections);
			collectionsTableView.setItems((ObservableList<Collection>) collectionsData);
			
			/*************Esempio a scopo inoformativo***************/
			List<String> stringList = new ArrayList<>();
			stringList.add("Mik");
			stringList.add("luca");
			stringList.add("Calogero");
			stringList.add("Giacomo");
			stringList.add("Enrico");
			stringList.add("Raffaele");
			SearchableComboBox<String> searchableComboBox = new SearchableComboBox<>(FXCollections.observableArrayList(stringList));
			searchableComboBox.setPrefWidth(245);
			searchableComboBox.setMaxWidth(245);
			searchableComboBox.setPrefHeight(26);
			searchableComboBox.setMaxHeight(26);
			searchableComboBox.setPromptText("Cerca...");
			parentHBox.getChildren().add(searchableComboBox);
			/********************************************************/
			
		} catch(DatabaseConnectionException e) {
			System.err.println(e.getMessage());
		}
	}
	
	@FXML
	private void logout() {
		dispatcher.logout();
	}
	
	@FXML
	private void inserisciCollezione() {
		dispatcher.renderView("insert_collection", collector);
	}

}
