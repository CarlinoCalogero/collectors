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
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;

public class CercaDiscoController implements Initializable, DataInitalizable<Collector> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
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
	private TableColumn<DiscoInCollezione, String> titleTableColumn, stateTableColumn, formatTableColumn;

	@FXML
	private TableColumn<DiscoInCollezione, Button> seeTableColumn, deleteTableColumn;

	@FXML
	private TableColumn<DiscoInCollezione, LocalDate> dateTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

		titleTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("titolo"));

		dateTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, LocalDate>("annoDiUscita"));

		stateTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("stato"));

		formatTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("formato"));

		seeTableColumn.setStyle("-fx-alignment: CENTER;");
		seeTableColumn.setCellValueFactory((CellDataFeatures<DiscoInCollezione, Button> param) -> {
			final Button seeButton = new Button("Visualizza");
			seeButton.setOnAction((ActionEvent event) -> {
				// dispatcher.renderView("see_disco", new Triple<Collector, Collection,
				// Disco>(collector, collection, param.getValue()));
			});
			return new SimpleObjectProperty<Button>(seeButton);
		});

		deleteTableColumn.setStyle("-fx-alignment: CENTER;");
		deleteTableColumn.setCellValueFactory((CellDataFeatures<DiscoInCollezione, Button> param) -> {
			final Button eliminaButton = new Button("Elimina");
			eliminaButton.setOnAction((ActionEvent event) -> {
				try {
					implementation.deleteDisco(param.getValue().getId());
					discoInCollezioneData.remove(param.getValue());
				} catch (DatabaseConnectionException e) {
					e.printStackTrace();
				}
			});
			return new SimpleObjectProperty<Button>(eliminaButton);
		});
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
			System.out.println(discoInCollezione);

		} catch (DatabaseConnectionException e) {
			e.printStackTrace();
		}

	}

}
