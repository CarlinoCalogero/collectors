package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.time.LocalDate;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Couple;
import it.univaq.disim.oop.collectors.domain.Disco;
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
import javafx.scene.control.TableView;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.cell.PropertyValueFactory;

public class SeeCollectionController implements Initializable, DataInitalizable<Couple<Collection,Collector>>{

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	private Collection collection;
	private Collector collector;
	
	@FXML
	private Label nameLabel, visibilityLabel;
	
	@FXML
	private TableView<Disco> discoTableView;
	
	@FXML
	private TableColumn<Disco,String> titleTableColumn, stateTableColumn, formatTableColumn;
	
	@FXML
	private TableColumn<Disco,Button> seeTableColumn;
	
	@FXML
	private TableColumn<Disco,LocalDate> dateTableColumn;
	
	@FXML
	private Button exitButton;
	
	@Override
	public void initialize(URL location, ResourceBundle resources) {
		titleTableColumn.setCellValueFactory(new PropertyValueFactory<Disco, String>("titolo"));
		dateTableColumn.setCellValueFactory(new PropertyValueFactory<Disco, LocalDate>("annoDiUscita"));
		stateTableColumn.setCellValueFactory(new PropertyValueFactory<Disco, String>("stato"));
		formatTableColumn.setCellValueFactory(new PropertyValueFactory<Disco, String>("formato"));
		seeTableColumn.setStyle("-fx-alignment: CENTER;");
		seeTableColumn.setCellValueFactory((CellDataFeatures<Disco, Button> param) -> {
			final Button seeButton = new Button("Visualizza");
			seeButton.setOnAction((ActionEvent event) -> {
				System.out.println("Visualizzando...");
			});
			return new SimpleObjectProperty<Button>(seeButton);
		});
	}
	
	public void initializeData(Couple<Collection,Collector> couple) {
		this.collection = couple.getFirst();
		this.collector = couple.getSecond();
		
		nameLabel.setStyle("-fx-font-style: italic;");
		visibilityLabel.setStyle("-fx-font-style: italic;");
		nameLabel.setText(collection.getNome());
		if(collection.getVisibilita()) {
			visibilityLabel.setText("Pubblica");
		} else visibilityLabel.setText("Privata");
		
		try {
			List<Disco> discos = implementation.getDischiInCollezione(collection.getID());
			ObservableList<Disco> discosData = FXCollections.observableArrayList(discos);
			discoTableView.setItems((ObservableList<Disco>) discosData);
		} catch (DatabaseConnectionException e) {
			e.printStackTrace();
		}
	}

	@FXML
	private void exit() {
		dispatcher.renderHome(collector);
	}
}
