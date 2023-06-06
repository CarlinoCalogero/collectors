package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.sql.SQLException;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
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
import javafx.scene.control.Menu;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;

public class HomeController implements Initializable, DataInitalizable<Collector>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
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
				System.out.println("Cancellando...");
			});
			return new SimpleObjectProperty<Button>(modifyButton);
		});
		modifyTableColumn.setStyle("-fx-alignment: CENTER;");
		modifyTableColumn.setCellValueFactory((CellDataFeatures<Collection, Button> param) -> {
			final Button modifyButton = new Button("Modifica");
			modifyButton.setOnAction((ActionEvent event) -> {
				System.out.println("Modificando...");
			});
			return new SimpleObjectProperty<Button>(modifyButton);
		});
	}
	
	public void initializeData(Collector collector) {
		benvenutoLabel.setText("Benvenuto "+collector.nickname);
		try {
			List<Collection> collections = implementation.getCollections(collector.ID);
			ObservableList<Collection> songsData = FXCollections.observableArrayList(collections);
			collectionsTableView.setItems((ObservableList<Collection>) songsData);
		} catch(SQLException e) {
			System.err.println(e.getMessage());
		}
	}
	
	@FXML
	private void logout() {
		System.out.println("OK");
		dispatcher.logout();
	}
	
	@FXML
	private void inserisciCollezione() {
		dispatcher.renderView("insert_collection", null);
	}

}
