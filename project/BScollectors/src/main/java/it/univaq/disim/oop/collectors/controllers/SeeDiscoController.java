package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Disco;
import it.univaq.disim.oop.collectors.domain.Track;
import it.univaq.disim.oop.collectors.domain.Triple;
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

public class SeeDiscoController implements Initializable, DataInitalizable<Triple<Collector,Collection,Disco>>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	private Collector collector;
	private Collection collection;
	private Disco disco;
	
	@FXML
	private Label titleLabel,dateLabel,stateLabel,formatLabel,etichettaLabel;
	
	@FXML
	private Button button;
	
	@FXML
	private TableView<Track> trackTableView;
	
	@FXML
	private TableColumn<Track,String> titleTableColumn;
	
	@FXML
	private TableColumn<Track,Float> durataTableColumn;
	
	@FXML
	private TableColumn<Track,Button> seeTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		
		titleTableColumn.setCellValueFactory(new PropertyValueFactory<Track, String>("titolo"));
		durataTableColumn.setStyle("-fx-alignment: CENTER;");
		durataTableColumn.setCellValueFactory(new PropertyValueFactory<Track, Float>("durata"));
		seeTableColumn.setStyle("-fx-alignment: CENTER;");
		seeTableColumn.setCellValueFactory((CellDataFeatures<Track, Button> param) -> {
			final Button seeButton = new Button("Visualizza");
			seeButton.setOnAction((ActionEvent event) -> {
				System.out.println("Visualizzando...");	
			});
			return new SimpleObjectProperty<Button>(seeButton);
		});
	}

	public void initializeData(Triple<Collector,Collection,Disco> triple) {
		this.collector = triple.getFirst();
		this.collection = triple.getSecond();
		this.disco = triple.getThird();
		
		titleLabel.setText(disco.getTitolo());
		dateLabel.setText(disco.getAnnoDiUscita().toString());
		stateLabel.setText(disco.getStato());
		formatLabel.setText(disco.getFormato());
		etichettaLabel.setText(disco.getEtichetta());
		
		List<Track> tracks = implementation.getTrackList(disco);
		trackTableView.setItems(FXCollections.observableArrayList(tracks));
	}
	
	@FXML
	private void exit() {
		dispatcher.renderHome(collector);
	}
}
