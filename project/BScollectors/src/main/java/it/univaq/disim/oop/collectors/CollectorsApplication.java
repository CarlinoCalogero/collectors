package it.univaq.disim.oop.collectors;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.application.Application;
import javafx.stage.Stage;

public class CollectorsApplication extends Application {
	public static void main(String[] args) {
		launch(args);
	}

	@Override
	public void start(Stage stage) throws Exception {
		try {
			BusinessFactory.getImplementation();
			BusinessFactory.getImplementation().deleteCollezione(10);
			ViewDispatcher.getInstance().login(stage);
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(0);
		}

	}

}
