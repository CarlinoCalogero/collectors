package it.univaq.disim.oop.collectors.business;

public abstract class BusinessFactory {
	private static BusinessFactory ramImpl;

	public static BusinessFactory getImplementation() {
		return ramImpl;
	}

}
