package it.univaq.disim.oop.collectors.viste;

import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

public class ViewDispatcher {
	private final String ESTENSIONE = ".fxml";
	private Stage stage;
	private BorderPane pane;
	private Scene scene;
	private static ViewDispatcher dispacher = new ViewDispatcher();
	
	private ViewDispatcher() {}
	
	public static ViewDispatcher getInstance() {
		return dispacher;
	}
	
	public void login(Stage s) {
		try {		
			this.stage = s;
			this.stage.setTitle("Collectors");
			this.stage.setResizable(false);
			Parent vista = caricaVista("login").getView();
			this.pane = (BorderPane)vista;
			this.scene = new Scene(vista);
			this.stage.setScene(this.scene);
			this.stage.show();
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(0);
		}
		
	}
	public<T> void renderVista(String nomeVista,T dato){
		try {
			View<T> view = caricaVista(nomeVista);
			DataInitalizable<T> controller = view.getController();
			controller.initializeData(dato);
			Parent	p = view.getView();
			this.pane.setCenter(p);
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(0);
		}
	}
	private <T> View<T> caricaVista(String nomeVista) {
		try {
			FXMLLoader loader= new FXMLLoader(getClass().getResource("/"+nomeVista+ESTENSIONE));
			View<T> vista = new View<T>(loader.load(), loader.getController());
			return vista;
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(0);
		}
		return null;
	}
}
