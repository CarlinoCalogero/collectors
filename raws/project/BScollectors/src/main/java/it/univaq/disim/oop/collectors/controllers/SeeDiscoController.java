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
import it.univaq.disim.oop.collectors.domain.InfoDisco;
import it.univaq.disim.oop.collectors.domain.Track;
import it.univaq.disim.oop.collectors.domain.Triple;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.collections.FXCollections;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;

public class SeeDiscoController implements Initializable, DataInitalizable<Triple<Collector, Collection, Disco>> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();

	private Collector collector;
	private Collection collection;
	private Disco disco;

	@FXML
	private Label titleLabel, dateLabel, generiLabel, stateLabel, formatLabel, etichettaLabel, copieLabel, barcodeLabel,
			noteLabel;
	
	@FXML
	private Button inserisciTracciaButton;

	@FXML
	private TableView<Track> trackTableView;

	@FXML
	private TableColumn<Track, String> titleTableColumn;

	@FXML
	private TableColumn<Track, Float> durataTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

		titleTableColumn.setCellValueFactory(new PropertyValueFactory<Track, String>("titolo"));
		durataTableColumn.setStyle("-fx-alignment: CENTER;");
		durataTableColumn.setCellValueFactory(new PropertyValueFactory<Track, Float>("durata"));

	}

	public void initializeData(Triple<Collector, Collection, Disco> triple) {
		this.collector = triple.getFirst();
		this.collection = triple.getSecond();
		this.disco = triple.getThird();

		titleLabel.setText(disco.getTitolo());
		dateLabel.setText(disco.getAnnoDiUscita().toString());
		stateLabel.setText(disco.getStato());
		formatLabel.setText(disco.getFormato());
		etichettaLabel.setText(disco.getEtichetta().getNome());
		try {
			InfoDisco infoDisco = implementation.getInfoDisco(disco.getId());
			if (infoDisco != null) {
				copieLabel.setText("" + infoDisco.getNumeroCopie());
				String barcode = infoDisco.getBarcode();
				if (barcode == null) {
					barcodeLabel.setText("");
				} else {
					barcodeLabel.setText("" + infoDisco.getBarcode());
				}

				noteLabel.setText("" + infoDisco.getNote());
			}
			List<String> generi = implementation.getGeneriDisco(disco.getId());
			if (generi != null) {
				String generiLabelText = null;
				for (String genere : generi) {
					if (generiLabelText == null)
						generiLabelText = genere;
					else
						generiLabelText = generiLabelText + ", " + genere;
				}
				generiLabel.setText(generiLabelText);
			}
			List<Track> tracks = implementation.getTrackList(disco.getId());
			trackTableView.setItems(FXCollections.observableArrayList(tracks));

		} catch (DatabaseConnectionException e) {
			e.printStackTrace();
		}

	}
	
	@FXML
	private void inserisciDisco() {
		dispatcher.renderView("insert_traccia", new Triple<Collection, Disco, Collector>(collection, disco, collector));
	}
}
