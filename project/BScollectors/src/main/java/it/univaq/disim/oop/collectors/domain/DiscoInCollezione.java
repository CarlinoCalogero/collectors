package it.univaq.disim.oop.collectors.domain;

import java.time.LocalDate;

public class DiscoInCollezione extends Disco {

	private final String collezione;
	private final String proprietario;

	public DiscoInCollezione(Integer id, String titolo, LocalDate annoDiUscita, String stato, String formato,
			Etichetta etichetta, String[] generi, String barcode, String note, int numeroCopie, String collezione,
			String proprietario) {
		super(id, titolo, annoDiUscita, stato, formato, etichetta, generi, barcode, note, numeroCopie);
		this.collezione = collezione;
		this.proprietario = proprietario;
	}

	public String getCollezione() {
		return collezione;
	}

	public String getProprietario() {
		return proprietario;
	}

	@Override
	public String toString() {
		return super.toString() + "DiscoInCollezione [collezione=" + collezione + ", proprietario=" + proprietario
				+ "]";
	}

}
