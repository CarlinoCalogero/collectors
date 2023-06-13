package it.univaq.disim.oop.collectors.domain;

public class NumeroCollezioniDiCollezionista {

	@Override
	public String toString() {
		return "NumeroCollezioniDiCollezionista [collezionista=" + collezionista + ", numeroCollezioni="
				+ numeroCollezioni + "]";
	}

	private final String collezionista;
	private final Integer numeroCollezioni;

	public NumeroCollezioniDiCollezionista(String collezionista, Integer numeroCollezioni) {
		super();
		this.collezionista = collezionista;
		this.numeroCollezioni = numeroCollezioni;
	}

	public String getCollezionista() {
		return collezionista;
	}

	public int getNumeroCollezioni() {
		return numeroCollezioni;
	}

}
