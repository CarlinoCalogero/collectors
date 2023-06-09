package it.univaq.disim.oop.collectors.domain;

public class Track {

	private final Integer ID;
	private final String titolo;
	private final Float durata;
	private final Disco disco;
	private final Etichetta etichetta;

	public Track(Integer iD, String titolo, Float durata, Disco disco, Etichetta etichetta) {
		this.ID = iD;
		this.titolo = titolo;
		this.durata = durata;
		this.disco = disco;
		this.etichetta = etichetta;
	}

	public Integer getID() {
		return ID;
	}

	public String getTitolo() {
		return titolo;
	}

	public Float getDurata() {
		return durata;
	}

	public Disco getDisco() {
		return disco;
	}

	public Etichetta getEtichetta() {
		return etichetta;
	}

}
