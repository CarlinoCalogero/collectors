package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.time.LocalDate;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.DiscoInCollezione;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;

public class CercaDiscoController implements Initializable, DataInitalizable<Collector> {

	private Query_JDBC implementation = BusinessFactory.getImplementation();

	private Collector collector;
	private ObservableList<DiscoInCollezione> discoInCollezioneData;

	@FXML
	private TextField autoreTextField, titoloTextField;

	@FXML
	private CheckBox privateCheckBox, condiviseCheckBox, pubblicheCheckBox;

	@FXML
	private Button cercaButton;

	@FXML
	private TableView<DiscoInCollezione> discoTableView;

	@FXML
	private TableColumn<DiscoInCollezione, String> titleTableColumn, stateTableColumn, formatTableColumn,
			collezioneTableColumn, proprietarioTableColumn;

	@FXML
	private TableColumn<DiscoInCollezione, LocalDate> dateTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

		titleTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("titolo"));

		dateTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, LocalDate>("annoDiUscita"));

		stateTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("stato"));

		formatTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("formato"));

		collezioneTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("collezione"));

		proprietarioTableColumn
				.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("proprietario"));

	}

	public void initializeData(Collector collector) {
		this.collector = collector;
	}

	@FXML
	private void cerca() {

		try {

			int autoreTextFieldLength = this.autoreTextField.getText().length();
			int titoloTextFieldLength = this.titoloTextField.getText().length();

			if ((autoreTextFieldLength == 0 && titoloTextFieldLength == 0) || (!this.privateCheckBox.isSelected()
					&& !this.condiviseCheckBox.isSelected() && !this.pubblicheCheckBox.isSelected()))
				return;

			String nomedarte;
			if (autoreTextFieldLength == 0) {
				nomedarte = null;
			} else {
				nomedarte = this.autoreTextField.getText();
			}

			String titolo;
			if (titoloTextFieldLength == 0) {
				titolo = null;
			} else {
				titolo = this.titoloTextField.getText();
			}

			List<DiscoInCollezione> discoInCollezione = implementation.ricercaDiDischiConAutoreEOTitolo(nomedarte,
					titolo, collector.getID(), this.privateCheckBox.isSelected(), this.condiviseCheckBox.isSelected(),
					this.pubblicheCheckBox.isSelected());
			discoInCollezioneData = FXCollections.observableArrayList(discoInCollezione);
			discoTableView.setItems((ObservableList<DiscoInCollezione>) discoInCollezioneData);

		} catch (DatabaseConnectionException e) {
			e.printStackTrace();
		}

	}

}
