package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Couple;
import it.univaq.disim.oop.collectors.domain.Visibilita;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.ImageView;

public class CollezioniPubblicheController implements Initializable, DataInitalizable<Collector> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();

	private Collector collector;
	private ObservableList<Collection> collectionsData;

	@FXML
	private ImageView searchImageView;

	@FXML
	private TableView<Collection> collectionsTableView;

	@FXML
	private TableColumn<Collection, String> nameTableColumn;

	@FXML
	private TableColumn<Collection, Visibilita> visibilityTableColumn;

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
		visibilityTableColumn.setCellValueFactory(new PropertyValueFactory<Collection, Visibilita>("visibilita"));

		seeTableColumn.setStyle("-fx-alignment: CENTER;");
		seeTableColumn.setCellValueFactory((CellDataFeatures<Collection, Button> param) -> {
			final Button seeButton = new Button("Visualizza");
			seeButton.setStyle(
					"-fx-background-color:#bacad7; -fx-background-radius: 15px; -fx-text-fill: #5f6569; -fx-font-weight: bold;");
			seeButton.setOnAction((ActionEvent event) -> {
				dispatcher.renderView("see_collection", new Couple<Collection, Collector>(param.getValue(), collector));
			});
			return new SimpleObjectProperty<Button>(seeButton);
		});

		deleteTableColumn.setStyle("-fx-alignment: CENTER;");
		deleteTableColumn.setCellValueFactory((CellDataFeatures<Collection, Button> param) -> {
			final Button deleteButton = new Button("Cancella");
			deleteButton.setStyle(
					"-fx-background-color: red; -fx-background-radius: 15px; -fx-text-fill: #ffffff; -fx-font-weight: bold;");
			deleteButton.setOnAction((ActionEvent event) -> {
				try {
					implementation.deleteCollezione(param.getValue().getID());
					collectionsData.remove(param.getValue());
				} catch (DatabaseConnectionException e) {
					e.printStackTrace();
				}
			});
			return new SimpleObjectProperty<Button>(deleteButton);
		});

		modifyTableColumn.setStyle("-fx-alignment: CENTER;");
		modifyTableColumn.setCellValueFactory((CellDataFeatures<Collection, Button> param) -> {
			final Button modifyButton = new Button("Modifica");
			modifyButton.setStyle(
					"-fx-background-color: green; -fx-background-radius: 15px; -fx-text-fill: #ffffff; -fx-font-weight: bold;");
			modifyButton.setOnAction((ActionEvent event) -> {
				dispatcher.renderView("modify_collection",
						new Couple<Collector, Collection>(collector, param.getValue()));
			});
			return new SimpleObjectProperty<Button>(modifyButton);
		});
	}

	public void initializeData(Collector collector) {

		this.collector = collector;

		try {

			List<Collection> collections = implementation.getPubblicCollections();
			collectionsData = FXCollections.observableArrayList(collections);
			collectionsTableView.setItems((ObservableList<Collection>) collectionsData);

		} catch (DatabaseConnectionException e) {
			System.err.println(e.getMessage());
		}
	}

	@FXML
	private void logout() {
		dispatcher.logout();
	}

	@FXML
	public void home() {
		dispatcher.renderHome(this.collector);
	}

}
