package it.univaq.disim.oop.collectors.domain;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

public class Disco {
	private final Integer id;
	private final String titolo;
	private final LocalDate annoDiUscita;
	private final String stato;
	private final String formato;
	private final String etichetta;
	private final Set<String> generi = new HashSet<String>();
	
	public Disco(Integer id, String titolo, LocalDate annoDiUscita, String stato, String formato, String etichetta,String[] generi) {
		this.id = id;
		this.titolo = titolo;
		this.annoDiUscita = annoDiUscita;
		this.stato = stato;
		this.formato = formato;
		this.etichetta = etichetta;
		for(String s: generi)
			this.generi.add(s);
	}

	public Integer getId() {
		return id;
	}

	public String getTitolo() {
		return titolo;
	}

	public LocalDate getAnnoDiUscita() {
		return annoDiUscita;
	}

	public String getStato() {
		return stato;
	}

	public String getFormato() {
		return formato;
	}

	public String getEtichetta() {
		return etichetta;
	}

	public Set<String> getGeneri() {
		return generi;
	}
	
}
