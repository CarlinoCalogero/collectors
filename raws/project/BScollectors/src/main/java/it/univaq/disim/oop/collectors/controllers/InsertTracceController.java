package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Disco;
import it.univaq.disim.oop.collectors.domain.Etichetta;
import it.univaq.disim.oop.collectors.domain.Track;
import it.univaq.disim.oop.collectors.domain.Triple;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.collections.FXCollections;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextField;
import javafx.util.StringConverter;

public class InsertTracceController implements Initializable, DataInitalizable<Triple<Collection, Disco, Collector>> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();

	private Collection collection;
	private Collector collector;
	private Disco disco;

	@FXML
	private TextField titoloTextField, durataTextField;

	@FXML
	private Button inserisciTracciaButton;

	@FXML
	private ComboBox<Etichetta> etichettaComboBox;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

		try {
			etichettaComboBox.setItems(FXCollections.observableArrayList(implementation.getAllEtichette()));

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

		} catch (DatabaseConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public void initializeData(Triple<Collection, Disco, Collector> triple) {

		this.collection = triple.getFirst();
		this.disco = triple.getSecond();
		this.collector = triple.getThird();

	}

	@FXML
	private void save() throws DatabaseConnectionException {

		if (this.titoloTextField.getText().length() == 0 || this.durataTextField.getText().length() == 0
				|| this.etichettaComboBox.getValue() == null)
			return;

		float durataTraccia = 0;
		try {
			durataTraccia = Float.parseFloat(this.durataTextField.getText());
		} catch (NumberFormatException e) {
			System.err.println("Not a Number");
			return;
		}

		try {
			implementation.aggiungiTracciaADisco(new Track(null, this.titoloTextField.getText(), durataTraccia, disco,
					this.etichettaComboBox.getValue()));
			;
		} catch (DatabaseConnectionException e) {
			e.printStackTrace();
		}
		dispatcher.renderView("see_disco", new Triple<Collector, Collection, Disco>(collector, collection, disco));
	}

}
