package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;

public class AdminHomeController implements Initializable, DataInitalizable<Collector> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();

	private Collector admin;

	@FXML
	private Button homeButton;

	@FXML
	private Button logoutButton;

	@FXML
	private Label benvenutoLabel;

	@FXML
	private Button autoriButton;

	@FXML
	private Button collezioniButton;

	@FXML
	private Button dischiButton;

	@Override
	public void initialize(URL location, ResourceBundle resources) {

	}

	public void initializeData(Collector admin) {

		benvenutoLabel.setText("Benvenuto " + admin.getNickname());
		this.admin = admin;

	}

	@FXML
	private void logout() {
		dispatcher.logout();
	}

	@FXML
	public void home() {
		dispatcher.renderAdminHome(this.admin);
	}

	@FXML
	private void renderVisualizzaAutori() {
		dispatcher.renderView("autori_admin", admin);
	}

	@FXML
	private void renderCollezioni() {
		dispatcher.renderView("collezioni_admin", admin);
	}

	@FXML
	private void renderDischi() {
		dispatcher.renderView("dischi_admin", admin);
	}

}
