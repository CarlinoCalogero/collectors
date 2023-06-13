package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.stream.Collectors;

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
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.geometry.Side;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.ContextMenu;
import javafx.scene.control.CustomMenuItem;
import javafx.scene.control.DatePicker;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.TableView;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.layout.HBox;
import javafx.util.StringConverter;

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
	private ComboBox<Etichetta> etichettaComboBox;
	@FXML
	private HBox HBoxTitolo;
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
	private TextField barcodeTextField, titoloTextField, numeroCopieTextField;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		try {
			generiComboBox.setItems(FXCollections.observableArrayList(implementation.getGenras()));
			statoComboBox.setItems(FXCollections.observableArrayList(implementation.getStates()));
			formatoComboBox.setItems(FXCollections.observableArrayList(implementation.getFormats()));
			etichettaComboBox.setItems(FXCollections.observableArrayList(implementation.getAllEtichette()));
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
			this.titoloTextField.setContextMenu(new ContextMenu());
			etichettaComboBox.setConverter(new StringConverter<Etichetta>() {
				@Override
				public String toString(Etichetta object) {
					return object.getNome();
				}

				@Override
				public Etichetta fromString(String string) {
					// TODO Auto-generated method stub
					return null;
				}
			});
			;
		} catch (DatabaseConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void initializeData(Couple<Collection, Collector> couple) {
		this.collection = couple.getFirst();
		this.collector = couple.getSecond();
		try {
			this.poolDischi.addAll(implementation.getAllDischi());
			for (DiscoInCollezione disco : this.poolDischi)
				if (disco.getBarcode() != null)
					barcodeMap.put(disco.getBarcode(), disco);

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

		try {
			Disco disco = new Disco(null, titoloTextField.getText(), dataPicker.getValue(), statoComboBox.getValue(),
					formatoComboBox.getValue(), etichettaComboBox.getValue(), generi.toArray(new String[generi.size()]),
					barcodeTextField.getText(), noteTextArea.getText(),
					Integer.parseInt(numeroCopieTextField.getText()));
			implementation.aggiungiDiscoACollezione(disco, collection.getID());
		} catch (DatabaseConnectionException e) {
			System.err.println(e);
		} catch (Exception e1) {
			System.err.println("Inserimento fallito");
		}
		dispatcher.renderHome(collector);
	}

	@FXML
	private void isSearching() {
		if (this.titoloTextField.getText().length() == 0) {
			this.titoloTextField.getContextMenu().hide();
			this.searchedWthTitle = null;
			return;
		}
		String titolo = titoloTextField.getText();
		List<DiscoInCollezione> filteredList = poolDischi.stream().filter(disco->disco.getTitolo().toLowerCase().contains(titolo.toLowerCase())).collect(Collectors.toList());
		Collections.sort(filteredList, new StringByLengthComparator(titolo, null));
		this.searchedWthTitle = filteredList.get(0);
		populateTextField(this.searchedWthTitle);
		if(this.titoloTextField.getContextMenu().getItems().size() > 0) {
			this.titoloTextField.getContextMenu().show(this.titoloTextField, Side.BOTTOM, 0, 0);
		}
	
	}

	@FXML
	private void isSearchingBarcode() {

		if (this.barcodeTextField.getText().length() == 0) {
			this.searchedWthBarcode = null;
			return;
		}
		if (barcodeTextField.getText().length() >= 5) {
			this.searchedWthBarcode = this.barcodeMap.get(barcodeTextField.getText());
			searchUnion();
		}
	}

	@FXML
	private void complete() {
		searchUnion();
		System.out.println(this.mostCoherent);
		if (this.mostCoherent != null) {
			this.titoloTextField.setText(this.mostCoherent.getTitolo());
			this.dataPicker.setValue(this.mostCoherent.getAnnoDiUscita());
			this.statoComboBox.setValue(this.mostCoherent.getStato());
			this.formatoComboBox.setValue(this.mostCoherent.getFormato());
			this.etichettaComboBox.setValue(this.mostCoherent.getEtichetta());
			this.barcodeTextField.setText(this.mostCoherent.getBarcode());
			this.noteTextArea.setText(this.mostCoherent.getNote());
			this.numeroCopieTextField.setText(String.valueOf(this.mostCoherent.getNumeroCopie()));
			this.generi.addAll(this.mostCoherent.getGeneri());
			this.generiTableView.setItems(FXCollections.observableArrayList(generi));
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
	private void populateTextField(DiscoInCollezione disco) {
		this.titoloTextField.getContextMenu();
		 CustomMenuItem item = new CustomMenuItem(new Label(disco.getTitolo()), true);
	      item.setOnAction(new EventHandler<ActionEvent>(){
	        @Override
	        public void handle(ActionEvent actionEvent) {
	        	complete();
	        }
	      });
	    titoloTextField.getContextMenu().getItems().clear();
	    titoloTextField.getContextMenu().getItems().add(item);
	}
}
