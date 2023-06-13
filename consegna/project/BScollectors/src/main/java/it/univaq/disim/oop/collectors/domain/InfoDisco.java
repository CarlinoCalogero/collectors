package it.univaq.disim.oop.collectors.domain;

public class InfoDisco {

	private final Integer idDisco;
	private final String barcode;
	private final String note;
	private final Integer numeroCopie;

	public InfoDisco(Integer idDisco, String barcode, String note, Integer numeroCopie) {
		super();
		this.idDisco = idDisco;
		this.barcode = barcode;
		this.note = note;
		this.numeroCopie = numeroCopie;
	}

	public Integer getIdDisco() {
		return idDisco;
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

}
