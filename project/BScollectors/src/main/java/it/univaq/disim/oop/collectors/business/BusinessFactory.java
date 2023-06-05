package it.univaq.disim.oop.collectors.business;

import it.univaq.disim.oop.collectors.business.JBCD.DBImplementation;
import it.univaq.disim.oop.collectors.business.JBCD.Query_JDBC;

public abstract class BusinessFactory {
	private static DBImplementation	implementation = new DBImplementation();
	public static Query_JDBC getImplementation(){
		return implementation.getImplementation();
	}
}
