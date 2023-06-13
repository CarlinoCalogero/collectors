package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Autore;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Couple;
import it.univaq.disim.oop.collectors.domain.TipoAutore;
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

public class AdminAutoriController implements Initializable, DataInitalizable<Collector> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();

	private Collector admin;
	private ObservableList<Autore> autoriData;

	@FXML
	private ImageView searchImageView;

	@FXML
	private TableView<Autore> autoriTableView;

	@FXML
	private TableColumn<Autore, String> nameTableColumn;

	@FXML
	private TableColumn<Autore, TipoAutore> tipoTableColumn;

	@FXML
	private TableColumn<Autore, Button> seeTableColumn;

	@FXML
	private TableColumn<Autore, Button> modifyTableColumn;

	@FXML
	private TableColumn<Autore, Button> deleteTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

		nameTableColumn.setCellValueFactory(new PropertyValueFactory<Autore, String>("nomedarte"));

		tipoTableColumn.setStyle("-fx-alignment: CENTER;");
		tipoTableColumn.setCellValueFactory(new PropertyValueFactory<Autore, TipoAutore>("tipoAutore"));

		seeTableColumn.setStyle("-fx-alignment: CENTER;");
		seeTableColumn.setCellValueFactory((CellDataFeatures<Autore, Button> param) -> {
			final Button seeButton = new Button("Visualizza");
			seeButton.setStyle(
					"-fx-background-color:#bacad7; -fx-background-radius: 15px; -fx-text-fill: #5f6569; -fx-font-weight: bold;");
			seeButton.setOnAction((ActionEvent event) -> {
				dispatcher.renderView("see_autore", new Couple<Autore, Collector>(param.getValue(), admin));
			});
			return new SimpleObjectProperty<Button>(seeButton);
		});

		deleteTableColumn.setStyle("-fx-alignment: CENTER;");
		deleteTableColumn.setCellValueFactory((CellDataFeatures<Autore, Button> param) -> {
			final Button deleteButton = new Button("Cancella");
			deleteButton.setStyle(
					"-fx-background-color: red; -fx-background-radius: 15px; -fx-text-fill: #ffffff; -fx-font-weight: bold;");
			deleteButton.setOnAction((ActionEvent event) -> {
				// function body goes here
			});
			return new SimpleObjectProperty<Button>(deleteButton);
		});

		modifyTableColumn.setStyle("-fx-alignment: CENTER;");
		modifyTableColumn.setCellValueFactory((CellDataFeatures<Autore, Button> param) -> {
			final Button modifyButton = new Button("Modifica");
			modifyButton.setStyle(
					"-fx-background-color: green; -fx-background-radius: 15px; -fx-text-fill: #ffffff; -fx-font-weight: bold;");
			modifyButton.setOnAction((ActionEvent event) -> {
				// function body goes here
			});
			return new SimpleObjectProperty<Button>(modifyButton);
		});
	}

	public void initializeData(Collector collector) {

		this.admin = collector;

		try {

			List<Autore> autori = implementation.getAutori();
			autoriData = FXCollections.observableArrayList(autori);
			autoriTableView.setItems((ObservableList<Autore>) autoriData);

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
		dispatcher.renderHome(this.admin);
	}

}
