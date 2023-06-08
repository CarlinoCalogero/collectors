package it.univaq.disim.oop.collectors.controllers;

import java.awt.Checkbox;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.ResourceBundle;

import org.controlsfx.control.PopOver;
import org.controlsfx.control.SearchableComboBox;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.DatabaseConnectionException;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Couple;
import it.univaq.disim.oop.collectors.domain.Disco;
import it.univaq.disim.oop.collectors.domain.DiscoInCollezione;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Background;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Paint;

public class CollezioniCondiviseController implements Initializable, DataInitalizable<Collector>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	private Collector collector;
	private ObservableList<Collection> collectionsData;
	
	@FXML
	private Button homeButton;
	
	@FXML
	private HBox parentHBox;
	
	@FXML
	private Button logoutButton;
	
	@FXML
	private Button inserisciCollezioneButton;
	
	@FXML
	private Label benvenutoLabel;
	
	@FXML
	private TextField searchTextField;
	
	@FXML
	private ImageView searchImageView;
	
	@FXML
	private TableView<Collection> collectionsTableView;
	
	@FXML
	private TableColumn<Collection, String> nameTableColumn;
	
	@FXML
	private TableColumn<Collection, Boolean>visibilityTableColumn;
	
	@FXML
	private TableColumn<Collection, Button> seeTableColumn;
	
	@FXML
	private TableColumn<Collection, Button> modifyTableColumn;
	
	@FXML
	private TableColumn<Collection, Button> deleteTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		
		buildPopOver();
				
		nameTableColumn.setCellValueFactory(new PropertyValueFactory<Collection, String>("nome"));
		visibilityTableColumn.setStyle("-fx-alignment: CENTER;");
		visibilityTableColumn.setCellValueFactory(new PropertyValueFactory<Collection, Boolean>("visibilita"));
		seeTableColumn.setStyle("-fx-alignment: CENTER;");
		seeTableColumn.setCellValueFactory((CellDataFeatures<Collection, Button> param) -> {
			final Button seeButton = new Button("Visualizza");
			seeButton.setStyle("-fx-background-color:#bacad7; -fx-background-radius: 15px; -fx-text-fill: #5f6569; -fx-font-weight: bold;");
			seeButton.setOnAction((ActionEvent event) -> {
				dispatcher.renderView("see_collection", new Couple<Collection,Collector>(param.getValue(),collector));
			});
			return new SimpleObjectProperty<Button>(seeButton);
		});
		deleteTableColumn.setStyle("-fx-alignment: CENTER;");
		deleteTableColumn.setCellValueFactory((CellDataFeatures<Collection, Button> param) -> {
			final Button deleteButton = new Button("Cancella");
			deleteButton.setStyle("-fx-background-color: red; -fx-background-radius: 15px; -fx-text-fill: #ffffff; -fx-font-weight: bold;");
			deleteButton.setOnAction((ActionEvent event) -> {
				try {
					implementation.deleteCollezione(param.getValue().getID());
					collectionsData.remove(param.getValue());
				} catch (DatabaseConnectionException e) {
					e.printStackTrace();
				}
			});
			return new SimpleObjectProperty<Button>(deleteButton);
		});
		modifyTableColumn.setStyle("-fx-alignment: CENTER;");
		modifyTableColumn.setCellValueFactory((CellDataFeatures<Collection, Button> param) -> {
			final Button modifyButton = new Button("Modifica");
			modifyButton.setStyle("-fx-background-color: green; -fx-background-radius: 15px; -fx-text-fill: #ffffff; -fx-font-weight: bold;");
			modifyButton.setOnAction((ActionEvent event) -> {
				dispatcher.renderView("modify_collection", new Couple<Collector, Collection>(collector, param.getValue()));
			});
			return new SimpleObjectProperty<Button>(modifyButton);
		});
	}
	
	public void initializeData(Collector collector) {
		benvenutoLabel.setText("Benvenuto "+collector.getNickname());
		this.collector = collector;
		try {
			List<Collection> collections = implementation.getCollections(collector.getID());
			collectionsData = FXCollections.observableArrayList(collections);
			collectionsTableView.setItems((ObservableList<Collection>) collectionsData);
			
			/*************Esempio a scopo inoformativo***************/
			List<String> stringList = new ArrayList<>();
			stringList.add("Mik");
			stringList.add("luca");
			stringList.add("Calogero");
			stringList.add("Giacomo");
			stringList.add("Enrico");
			stringList.add("Raffaele");
			stringList.add("Raffaelelle");
			stringList.add("Raffaelino");
			stringList.add("Raffaeluccio");
			Collections.sort(stringList, (s1, s2) -> {
				if(s2.length()==s1.length()) return s2.compareTo(s1);
				return s2.length()-s1.length();
			});
			SearchableComboBox<String> searchableComboBox = new SearchableComboBox<>(FXCollections.observableArrayList(stringList));
			searchableComboBox.setPrefWidth(245);
			searchableComboBox.setMaxWidth(245);
			searchableComboBox.setPrefHeight(26);
			searchableComboBox.setMaxHeight(26);
			searchableComboBox.setPromptText("Cerca...");
			parentHBox.getChildren().add(searchableComboBox);
			
			
			/********************************************************/
			
		} catch(DatabaseConnectionException e) {
			System.err.println(e.getMessage());
		}
	}
	
	private void buildPopOver() {
		VBox v = new VBox();
		Label l = new Label("Cerca disco:");
		TextField nomedarteTextField = new TextField();
		TextField titoloTextField = new TextField();
		HBox space = new HBox();
		space.setMinHeight(5);
		
		CheckBox personali = new CheckBox("Private");
		CheckBox pubbliche = new CheckBox("Pubbliche");
		CheckBox condivise = new CheckBox("Condivise");
		HBox h = new HBox();
		h.getChildren().add(personali);
		h.getChildren().add(pubbliche);
		h.getChildren().add(condivise);
		HBox.setMargin(personali, new Insets(5,5,0,0));
		HBox.setMargin(pubbliche, new Insets(5,5,0,0));
		HBox.setMargin(condivise, new Insets(5,0,0,0));
		nomedarteTextField.setPromptText("Nome d'arte...");
		nomedarteTextField.setMinWidth(100);
		titoloTextField.setPromptText("Titolo...");
		titoloTextField.setMinWidth(100);
		v.getChildren().add(l);
		v.getChildren().add(nomedarteTextField);
		v.getChildren().add(space);
		v.getChildren().add(titoloTextField);
		v.setPadding(new Insets(5,5,5,5));
		v.getChildren().add(h);
		Button button = new Button("Cerca");
		HBox hb = new HBox();
		hb.getChildren().add(button);
		hb.setAlignment(Pos.CENTER);
		PopOver popOver = new PopOver(v);
		popOver.setAutoFix(true);
		popOver.setHideOnEscape(true);
		popOver.setDetachable(false);
		popOver.setDetached(false);
		v.getChildren().add(hb);
		popOver.setArrowLocation(PopOver.ArrowLocation.TOP_CENTER);
		searchImageView.setOnMouseEntered(e -> {
			popOver.show(searchImageView);
		});
		button.setOnMouseClicked(event -> {
			try {
				List<DiscoInCollezione> discos = implementation.ricercaDiDischiConAutoreEOTitolo(
						nomedarteTextField.getText(), 
						titoloTextField.getText(), 
						collector, 
						personali.isSelected(), 
						condivise.isSelected(),
						pubbliche.isSelected());
				dispatcher.renderView("visible_disco", discos);
			} catch (DatabaseConnectionException e1) {
				e1.printStackTrace();
			}
			
		});
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
	private void inserisciCollezione() {
		dispatcher.renderView("insert_collection", collector);
	}

}
