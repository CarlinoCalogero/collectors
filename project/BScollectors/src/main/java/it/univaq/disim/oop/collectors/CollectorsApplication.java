package it.univaq.disim.oop.collectors;

import it.univaq.disim.oop.collectors.business.BusinessFactory;
import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.NumeroCollezioniDiCollezionista;
import it.univaq.disim.oop.collectors.domain.NumeroDischiPerGenere;
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
			System.out.println(BusinessFactory.getImplementation().verifica_visibilita_collezione(new Collection(1,null,null,null), new Collector(1,null,null)));
			ViewDispatcher.getInstance().login(stage);
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(0);
		}

	}

}
