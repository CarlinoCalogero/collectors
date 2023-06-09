package it.univaq.disim.oop.collectors.viste;

import javafx.scene.Parent;

public class View<T> {
	private Parent view;
	private DataInitalizable<T> controller;

	public View(Parent view, DataInitalizable<T> controller) {
		this.view = view;
		this.controller = controller;
	}

	public Parent getView() {
		return view;
	}

	public void setView(Parent view) {
		this.view = view;
	}

	public DataInitalizable<T> getController() {
		return controller;
	}

	public void setController(DataInitalizable<T> controller) {
		this.controller = controller;
	}
	
}
