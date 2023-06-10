package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.NumeroCollezioniDiCollezionista;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.ImageView;

public class AdminCollezioniController implements Initializable, DataInitalizable<Collector> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();

	private Collector admin;
	private ObservableList<NumeroCollezioniDiCollezionista> collectionsData;

	@FXML
	private ImageView searchImageView;

	@FXML
	private TableView<NumeroCollezioniDiCollezionista> collectorsTableView;

	@FXML
	private TableColumn<NumeroCollezioniDiCollezionista, String> nicknameTableColumn;

	@FXML
	private TableColumn<NumeroCollezioniDiCollezionista, Integer> numeroDiCollezioniTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

		nicknameTableColumn.setCellValueFactory(
				new PropertyValueFactory<NumeroCollezioniDiCollezionista, String>("collezionista"));

		numeroDiCollezioniTableColumn.setStyle("-fx-alignment: CENTER;");
		numeroDiCollezioniTableColumn.setCellValueFactory(
				new PropertyValueFactory<NumeroCollezioniDiCollezionista, Integer>("numeroCollezioni"));

	}

	public void initializeData(Collector admin) {

		this.admin = admin;

		try {

			List<NumeroCollezioniDiCollezionista> collezionistiENumeroCollezioni = implementation.contaCollezioni();
			collectionsData = FXCollections.observableArrayList(collezionistiENumeroCollezioni);
			collectorsTableView.setItems((ObservableList<NumeroCollezioniDiCollezionista>) collectionsData);

		} catch (DatabaseConnectionException e) {
			System.err.println(e.getMessage());
		}
	}

	@FXML
	private void logout() {
		dispatcher.logout();
	}

	@FXML
	public void home() {
		dispatcher.renderAdminHome(this.admin);
	}

}
