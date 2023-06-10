package it.univaq.disim.oop.collectors;

import it.univaq.disim.oop.collectors.viste.ViewDispatcher;
import javafx.application.Application;
import javafx.stage.Stage;

/*
 * Query implementate:
 * 1,2_1,3,3_1,4,5,6,7,8,
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
			// System.out.println(BusinessFactory.getImplementation().contaMinutiAutore("pink
			// floyd"));
			ViewDispatcher.getInstance().login(stage);

		} catch (Exception e) {
			e.printStackTrace();
			System.exit(0);
		}

	}

}


/* 
 * VM Arguments:
 * --module-path "C:\Program Files (x86)\JavaFX versions\javafx-sdk-18.0.1\lib" --add-modules javafx.controls,javafx.fxml --add-modules javafx.controls,javafx.media
 */