package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;

public class HomeController implements Initializable, DataInitalizable<Collector> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();

	private Collector collector;
	private ObservableList<Collection> collectionsData;

	@FXML
	private Button homeButton;

	@FXML
	private Button logoutButton;

	@FXML
	private Label benvenutoLabel;

	@FXML
	private Button collezioniPrivateButton;

	@FXML
	private Button collezioniCondiviseButton;

	@FXML
	private Button collezioniTutteButton;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

	}

	public void initializeData(Collector collector) {
		benvenutoLabel.setText("Benvenuto " + collector.getNickname());
		this.collector = collector;

		/*
		 * try {
		 * 
		 * } catch(DatabaseConnectionException e) { System.err.println(e.getMessage());
		 * }
		 */
	}

	@FXML
	private void logout() {
		dispatcher.logout();
	}

	@FXML
	public void home() {
		dispatcher.renderHome(this.collector);
	}

	@FXML
	private void renderCollezioniPrivate() {
		dispatcher.renderView("collezioni_private", collector);
	}

}
