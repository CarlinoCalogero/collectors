package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.time.LocalDate;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.domain.DiscoInCollezione;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import javafx.collections.FXCollections;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;

public class VisibleDiscoController implements Initializable, DataInitalizable<List<DiscoInCollezione>> {

	@FXML
	private TableView<DiscoInCollezione> discoTableView;

	@FXML
	private TableColumn<DiscoInCollezione, String> titoloTableColumn, statoTableColumn, formatoTableColumn,
			collezioneTableColumn, proprietarioTableColumn;

	@FXML
	private TableColumn<DiscoInCollezione, LocalDate> dataTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

		titoloTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("titolo"));
		statoTableColumn.setStyle("-fx-alignment: CENTER;");
		statoTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("condizioni"));
		formatoTableColumn.setStyle("-fx-alignment: CENTER;");
		formatoTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("formato"));
		collezioneTableColumn.setStyle("-fx-alignment: CENTER;");
		collezioneTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("collezione"));
		proprietarioTableColumn.setStyle("-fx-alignment: CENTER;");
		proprietarioTableColumn
				.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, String>("proprietario"));
		dataTableColumn.setStyle("-fx-alignment: CENTER;");
		dataTableColumn.setCellValueFactory(new PropertyValueFactory<DiscoInCollezione, LocalDate>("annoDiUscita"));

	}

	public void initializeData(List<DiscoInCollezione> discos) {

		discoTableView.setItems(FXCollections.observableArrayList(discos));
	}
}
