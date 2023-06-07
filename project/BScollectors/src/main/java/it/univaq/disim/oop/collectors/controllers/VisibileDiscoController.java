package it.univaq.disim.oop.collectors.controllers;

import java.net.URL;
import java.time.LocalDate;
import java.util.List;
import java.util.ResourceBundle;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Couple;
import it.univaq.disim.oop.collectors.domain.Disco;
import it.univaq.disim.oop.collectors.viste.DataInitalizable;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.collections.FXCollections;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;

public class VisibileDiscoController implements Initializable,DataInitalizable<List<Disco>>{
	
	private ViewDispatcher dispatcher = ViewDispatcher.getInstance();
	private Query_JDBC implementation = BusinessFactory.getImplementation();
	
	private Collector collector;
	private List<Disco> discos;
	
	@FXML
	private Button exitButton;
	
	@FXML
	private TableView<Disco> discoTableView;
	
	@FXML
	private TableColumn<Disco,String> titoloTableColumn, statoTableColumn, 
	formatoTableColumn, etichettaTableColumn, barcodeTableColumn, generiTableColumn;
	
	@FXML
	private TableColumn<Disco,LocalDate> dataTableColumn;

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		
	}
	
	public void initializeData(Couple<Collector,List<Disco>> couple) {
		
		this.collector = couple.getFirst();
		this.discos = couple.getSecond();
		
		discoTableView.setItems(FXCollections.observableArrayList(discos));
	}
	
	@FXML
	private void exit() {
		dispatcher.renderHome(collector);
	}

}
