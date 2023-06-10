package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.NumeroDischiPerGenere;
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

public class AdminDischiController implements Initializable, DataInitalizable<Collector> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();

	private Collector admin;
	private ObservableList<NumeroDischiPerGenere> collectionsData;

	@FXML
	private ImageView searchImageView;

	@FXML
	private TableView<NumeroDischiPerGenere> generiTableView;

	@FXML
	private TableColumn<NumeroDischiPerGenere, String> nomeGenereTableColumn;

	@FXML
	private TableColumn<NumeroDischiPerGenere, Integer> numeroDiDischiTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

		nomeGenereTableColumn.setCellValueFactory(
				new PropertyValueFactory<NumeroDischiPerGenere, String>("genere"));

		numeroDiDischiTableColumn.setStyle("-fx-alignment: CENTER;");
		numeroDiDischiTableColumn.setCellValueFactory(
				new PropertyValueFactory<NumeroDischiPerGenere, Integer>("numeroDischi"));

	}

	public void initializeData(Collector admin) {

		this.admin = admin;

		try {

			List<NumeroDischiPerGenere> dischiPerGenere = implementation.contaDischiPerGenere();
			collectionsData = FXCollections.observableArrayList(dischiPerGenere);
			generiTableView.setItems((ObservableList<NumeroDischiPerGenere>) collectionsData);

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
