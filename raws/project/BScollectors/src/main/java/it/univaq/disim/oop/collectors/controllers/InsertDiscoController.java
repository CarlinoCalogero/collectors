package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.ResourceBundle;
import java.util.Set;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.business.JBCD.StringByLengthComparator;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Couple;
import it.univaq.disim.oop.collectors.domain.Disco;
import it.univaq.disim.oop.collectors.domain.DiscoInCollezione;
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

public class InsertDiscoController implements Initializable, DataInitalizable<Couple<Collection, Collector>> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();

	private Set<String> generi = new HashSet<String>();
	private List<DiscoInCollezione> poolDischi = new ArrayList<DiscoInCollezione>();
	private Map<String, DiscoInCollezione> barcodeMap = new HashMap<String, DiscoInCollezione>();
	private Collection collection;
	private Collector collector;
	private DiscoInCollezione searchedWthBarcode, searchedWthTitle, mostCoherent;
	@FXML
	private Button saveButton;

	@FXML
	private ComboBox<String> formatoComboBox, statoComboBox, generiComboBox;

	@FXML
	private DatePicker dataPicker;

	@FXML
	private TableView<String> generiTableView;

	@FXML
	private TableColumn<String, String> nomeGenereColumn;

	@FXML
	private TableColumn<String, Button> removeGenereColumn;

	@FXML
	private TextArea noteTextArea;

	@FXML
	private TextField barcodeTextField, titoloTextField, etichettaTextField, numeroCopieTextField;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		try {
			statoComboBox.setItems(FXCollections.observableArrayList(implementation.getStates()));
			formatoComboBox.setItems(FXCollections.observableArrayList(implementation.getFormats()));
			nomeGenereColumn.setCellValueFactory((CellDataFeatures<String, String> param) -> {
				return new SimpleObjectProperty<String>(param.getValue());
			});
			removeGenereColumn.setCellValueFactory((CellDataFeatures<String, Button> param) -> {
				final Button rimuoviButton = new Button("Rimuovi");
				rimuoviButton.setOnAction((ActionEvent event) -> {
					this.generi.remove(param.getValue());
					this.generiTableView.getItems().remove(param.getValue());
					System.out.println(this.generi);
				});
				return new SimpleObjectProperty<Button>(rimuoviButton);
			});
			this.generiTableView.setItems(FXCollections.observableArrayList());
		} catch (DatabaseConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void initializeData(Couple<Collection, Collector> couple) {
		this.collection = couple.getFirst();
		this.collector = couple.getSecond();
		try {
			this.poolDischi = implementation.getAllDischi();
			for (DiscoInCollezione disco : this.poolDischi)
				if (disco.getBarcode() != null)
					barcodeMap.put(disco.getBarcode(), disco);
			this.generiComboBox.setItems(FXCollections.observableArrayList(implementation.getGenras()));
		} catch (DatabaseConnectionException e) {
			e.printStackTrace();
		}
	}

	@FXML
	private void addGenere() {
		String genere = this.generiComboBox.getValue();
		if (genere != null) {
			this.generi.add(genere);
			this.generiTableView.setItems(FXCollections.observableArrayList(generi));
		}
		System.out.println(this.generi);
	}

	@FXML
	private void save() throws DatabaseConnectionException {
		List<Etichetta> etichette = implementation.getEtichette();
		Etichetta etichetta = null;
		Iterator<Etichetta> iteratore = etichette.iterator();
		while (iteratore.hasNext()) {
			etichetta = iteratore.next();
			if (etichetta.getNome().equalsIgnoreCase(etichettaTextField.getText())) {
				break;
			}
		}

		Disco disco = new Disco(null, titoloTextField.getText(), dataPicker.getValue(), statoComboBox.getValue(),
				formatoComboBox.getValue(), etichetta, generi.toArray(new String[generi.size()]),
				barcodeTextField.getText(), noteTextArea.getText(), Integer.parseInt(numeroCopieTextField.getText()));
		try {
			implementation.aggiungiDiscoACollezione(disco, collection.getID());
		} catch (DatabaseConnectionException e) {
			System.err.println(e);
		}
		dispatcher.renderHome(collector);
	}

	@FXML
	private void isSearching() {
		if (this.titoloTextField.getText().length() == 0) {
			this.searchedWthTitle = null;
			return;
		}
		String titolo = titoloTextField.getText();
		Collections.sort(poolDischi, new StringByLengthComparator(titolo, null));
		this.searchedWthTitle = poolDischi.get(0);
	}

	@FXML
	private void isSearchingBarcode() {

		if (this.barcodeTextField.getText().length() == 0) {
			this.searchedWthBarcode = null;
			return;
		}
		if (barcodeTextField.getText().length() >= 5) {
			this.searchedWthBarcode = this.barcodeMap.get(barcodeTextField.getText());
		}
	}

	@FXML
	private void complete() {
		searchUnion();
		System.out.println(this.mostCoherent);
		if (this.mostCoherent != null) {
			this.titoloTextField.setText(this.mostCoherent.getTitolo());
			this.dataPicker.setValue(this.mostCoherent.getAnnoDiUscita());
			this.statoComboBox.setValue(this.mostCoherent.getStato()); // Da cambiare
			this.formatoComboBox.setValue(this.mostCoherent.getFormato()); // Da cambiare
			this.etichettaTextField.setText(this.mostCoherent.getEtichetta().getNome());
			this.noteTextArea.setText(this.mostCoherent.getNote());
			this.numeroCopieTextField.setText(String.valueOf(this.mostCoherent.getNumeroCopie()));
		}
	}

	private void searchUnion() {
		if (Objects.equals(this.searchedWthTitle, this.searchedWthBarcode) || this.searchedWthTitle == null) {
			this.mostCoherent = this.searchedWthBarcode;
			return;
		}
		if (this.searchedWthBarcode == null) {
			this.mostCoherent = this.searchedWthTitle;
			return;
		}
		this.mostCoherent = null;
	}
}
