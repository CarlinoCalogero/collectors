package it.univaq.disim.oop.collectors.domain;

public class NumeroDischiPerGenere {

	private final String genere;
	private final Integer numeroDischi;

	public NumeroDischiPerGenere(String genere, Integer numeroDischi) {
		super();
		this.genere = genere;
		this.numeroDischi = numeroDischi;
	}

	public String getGenere() {
		return genere;
	}

	public Integer getNumeroDischi() {
		return numeroDischi;
	}

}
