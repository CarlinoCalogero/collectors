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
	private final Etichetta etichetta;
	private final Set<String> generi = new HashSet<String>();
	private final String barcode;
	private final String note;
	private int numeroCopie = 1;

	public Disco(Integer id, String titolo, LocalDate annoDiUscita, String stato, String formato, Etichetta etichetta,
			String[] generi, String barcode, String note, int numeroCopie) {
		this.id = id;
		this.titolo = titolo;
		this.annoDiUscita = annoDiUscita;
		this.stato = stato;
		this.formato = formato;
		this.etichetta = etichetta;
		for (String s : generi)
			this.generi.add(s);
		this.barcode = barcode;
		this.note = note;
		if (numeroCopie != null) {
			this.numeroCopie = numeroCopie;
		}
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

	public Etichetta getEtichetta() {
		return etichetta;
	}

	public Set<String> getGeneri() {
		return new HashSet<String>(generi);
	}

	public String getBarcode() {
		return barcode;
	}

	public String getNote() {
		return note;
	}

	public Integer getNumeroCopie() {
		return numeroCopie;
	}

	@Override
	public String toString() {
		return "Disco [id=" + id + ", titolo=" + titolo + ", annoDiUscita=" + annoDiUscita + ", stato=" + stato
				+ ", formato=" + formato + ", etichetta=" + etichetta + ", generi=" + generi + "]";
	}

}
