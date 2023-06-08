package it.univaq.disim.oop.collectors;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.NumeroCollezioniDiCollezionista;
import it.univaq.disim.oop.collectors.domain.NumeroDischiPerGenere;
import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.application.Application;
import javafx.stage.Stage;


/*
 * Query implementate:
 * 1,2_1,3,3_1,4,5
 * 
 * 
 * 
 * 
 */
public class CollectorsApplication extends Application {
	public static void main(String[] args) {
		launch(args);
	}

	@Override
	public void start(Stage stage) throws Exception {
		try {
			BusinessFactory.getImplementation();
			ViewDispatcher.getInstance().login(stage);
			
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(0);
		}

	}

}
