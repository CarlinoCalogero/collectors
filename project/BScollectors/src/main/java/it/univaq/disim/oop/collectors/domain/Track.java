package it.univaq.disim.oop.collectors.domain;

public class Track {
	
	private final Integer ID;
	private final String titolo;
	private final Float durata;
	private final Integer ID_disco;
	private final Integer ID_etichetta;
	
	public Track(Integer iD, String titolo, Float durata, Integer iD_disco, Integer iD_etichetta) {
		this.ID = iD;
		this.titolo = titolo;
		this.durata = durata;
		this.ID_disco = iD_disco;
		this.ID_etichetta = iD_etichetta;
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

	public Integer getID_disco() {
		return ID_disco;
	}

	public Integer getID_etichetta() {
		return ID_etichetta;
	}
}
