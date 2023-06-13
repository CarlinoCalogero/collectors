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
import javafx.scene.image.ImageView;
import javafx.scene.shape.Rectangle;

public class HomeController implements Initializable, DataInitalizable<Collector> {

	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();

	private Collector collector;

	@FXML
	private Button homeButton, logoutButton;

	@FXML
	private Label benvenutoLabel;
	
	@FXML
	private ImageView privateImageView, pubblicheImageView,condiviseImageView,tutteImageView,cercaImageView;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		roundImageView(cercaImageView);
		roundImageView(privateImageView);
		roundImageView(pubblicheImageView);
		roundImageView(condiviseImageView);
		roundImageView(tutteImageView);
		
	}
	
	private void roundImageView(ImageView imageView) {
		Rectangle rectangle = new Rectangle(0, 0, 150, 150);
		rectangle.setArcWidth(20);
        rectangle.setArcHeight(20);
		imageView.setClip(rectangle);
	}

	public void initializeData(Collector collector) {

		benvenutoLabel.setText("Benvenuto " + collector.getNickname());
		this.collector = collector;

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
		dispatcher.renderView("collezioni_mie", collector);
	}

	@FXML
	private void renderCollezioniCondivise() {
		dispatcher.renderView("collezioni_condivise", collector);
	}

	@FXML
	private void renderCollezioniPubbliche() {
		dispatcher.renderView("collezioni_pubbliche", collector);
	}

	@FXML
	private void renderCollezioniTutte() {
		dispatcher.renderView("collezioni_tutte", collector);
	}

	@FXML
	private void cercaDisco() {
		dispatcher.renderView("cerca_disco", collector);
	}

}