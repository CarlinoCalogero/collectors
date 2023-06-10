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
import it.univaq.disim.oop.collectors.domain.TracciaECollezione;
import it.univaq.disim.oop.collectors.domain.Visibilita;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.collections.FXCollections;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;

public class SeeAutoriController implements Initializable, DataInitalizable<Couple<Autore, Collector>> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();

	private Collector admin;
	private Autore autore;

	@FXML
	private Label nomeDarteAutoreLabel, tipoAutoreLabel, numeroTraccePubblicheLabel, minutiTotaliMusicaPubblicheLabel;

	@FXML
	private TableView<TracciaECollezione> trackTableView;

	@FXML
	private TableColumn<TracciaECollezione, String> titleTableColumn;

	@FXML
	private TableColumn<TracciaECollezione, Float> durataTableColumn;

	@FXML
	private TableColumn<TracciaECollezione, Visibilita> collezioneTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

		titleTableColumn.setCellValueFactory(new PropertyValueFactory<TracciaECollezione, String>("titolo"));
		durataTableColumn.setStyle("-fx-alignment: CENTER;");
		durataTableColumn.setCellValueFactory(new PropertyValueFactory<TracciaECollezione, Float>("durata"));
		collezioneTableColumn.setStyle("-fx-alignment: CENTER;");
		collezioneTableColumn
				.setCellValueFactory(new PropertyValueFactory<TracciaECollezione, Visibilita>("visibilita"));

	}

	public void initializeData(Couple<Autore, Collector> couple) {
		this.autore = couple.getFirst();
		this.admin = couple.getSecond();

		nomeDarteAutoreLabel.setText(autore.getNomedarte());
		tipoAutoreLabel.setText(autore.getTipoAutore().toString());

		try {
			numeroTraccePubblicheLabel.setText("" + implementation.getNumberOfTracks(autore.getNomedarte()));
			minutiTotaliMusicaPubblicheLabel.setText("" + implementation.contaMinutiAutore(autore.getNomedarte()));
			List<TracciaECollezione> tracks = implementation.getTrackListAutori(autore);
			trackTableView.setItems(FXCollections.observableArrayList(tracks));

		} catch (DatabaseConnectionException e) {
			e.printStackTrace();
		}

	}
}
