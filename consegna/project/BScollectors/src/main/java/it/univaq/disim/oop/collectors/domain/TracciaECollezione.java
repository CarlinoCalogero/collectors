package it.univaq.disim.oop.collectors.domain;

public class TracciaECollezione extends Track {

	private Integer idCollezione;
	private Visibilita visibilita;

	public TracciaECollezione(Integer idTraccia, String titoloTraccia, Float durataTraccia, Disco discoTraccia,
			Etichetta etichettaTraccia, Integer idCollezione, Visibilita visibilitaCollezione) {
		super(idTraccia, titoloTraccia, durataTraccia, discoTraccia, etichettaTraccia);
		this.idCollezione = idCollezione;
		this.visibilita = visibilitaCollezione;
	}

	public Integer getIdCollezione() {
		return idCollezione;
	}

	public void setIdCollezione(Integer idCollezione) {
		this.idCollezione = idCollezione;
	}

	public Visibilita getVisibilita() {
		return visibilita;
	}

	public void setVisibilita(Visibilita visibilita) {
		this.visibilita = visibilita;
	}

}
