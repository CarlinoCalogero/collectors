package it.univaq.disim.oop.collectors.domain;

import java.time.LocalDate;

public class DiscoInCollezione {

	private final String titolo;
	private final LocalDate annoDiUscita;
	private final String formato;
	private final String condizioni;
	private final String collezione;
	private final String proprietario;

	public DiscoInCollezione(String titolo, LocalDate annoDiUscita, String formato, String condizioni,
			String collezione, String proprietario) {
		super();
		this.titolo = titolo;
		this.annoDiUscita = annoDiUscita;
		this.formato = formato;
		this.condizioni = condizioni;
		this.collezione = collezione;
		this.proprietario = proprietario;
	}

	public String getTitolo() {
		return titolo;
	}

	public LocalDate getAnnoDiUscita() {
		return annoDiUscita;
	}

	public String getFormato() {
		return formato;
	}

	public String getCondizioni() {
		return condizioni;
	}

	public String getCollezione() {
		return collezione;
	}

	public String getProprietario() {
		return proprietario;
	}

	@Override
	public String toString() {
		return "DiscoInCollezione [titolo=" + titolo + ", annoDiUscita=" + annoDiUscita + ", formato=" + formato
				+ ", condizioni=" + condizioni + ", collezione=" + collezione + ", proprietario=" + proprietario + "]";
	}
	
	

}
