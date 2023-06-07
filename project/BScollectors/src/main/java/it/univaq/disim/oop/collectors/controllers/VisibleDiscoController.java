package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.time.LocalDate;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Couple;
import it.univaq.disim.oop.collectors.domain.Disco;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.cell.PropertyValueFactory;

public class VisibleDiscoController implements Initializable,DataInitalizable<List<Disco>>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	private List<Disco> discos;
	
	@FXML
	private TableView<Disco> discoTableView;
	
	@FXML
	private TableColumn<Disco,String> titoloTableColumn, statoTableColumn, 
	formatoTableColumn, collezioneTableColumn, proprietarioTableColumn;
	
	@FXML
	private TableColumn<Disco,LocalDate> dataTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		
		titoloTableColumn.setCellValueFactory(new PropertyValueFactory<Disco, String>("titolo"));
		statoTableColumn.setStyle("-fx-alignment: CENTER;");
		statoTableColumn.setCellValueFactory(new PropertyValueFactory<Disco, String>("stato"));
		formatoTableColumn.setStyle("-fx-alignment: CENTER;");
		formatoTableColumn.setCellValueFactory(new PropertyValueFactory<Disco, String>("formato"));
		collezioneTableColumn.setStyle("-fx-alignment: CENTER;");
		//collezioneTableColumn.setCellValueFactory((CellDataFeatures<Disco, String> param) -> {
			//return new SimpleObjectProperty<String>(param.getValue().get);
		//});
		proprietarioTableColumn.setStyle("-fx-alignment: CENTER;");
		//proprietarioTableColumn.setCellValueFactory((CellDataFeatures<Disco, String> param) -> {
			//return new SimpleObjectProperty<String>(param.getValue().get);
		//});
		
		dataTableColumn.setStyle("-fx-alignment: CENTER;");
		dataTableColumn.setCellValueFactory(new PropertyValueFactory<Disco, LocalDate>("annoDiUscita"));
		
	}
	
	public void initializeData(List<Disco> discos) {
		
		this.discos = discos;
		
		discoTableView.setItems(FXCollections.observableArrayList(discos));
	}
}
