package it.univaq.disim.oop.collectors.domain;

public class Collection {

	private final Integer ID;
	private final String nome;
	private final Visibilita visibilita;
	private final Integer ID_collezionista;

	public Collection(Integer ID, String nome, Visibilita visibilita, Integer ID_collezionista) {
		this.ID = ID;
		this.nome = nome;
		this.visibilita = visibilita;
		this.ID_collezionista = ID_collezionista;
	}

	public Integer getID() {
		return ID;
	}

	public String getNome() {
		return nome;
	}

	public Visibilita getVisibilita() {
		return visibilita;
	}

	public Integer getID_collezionista() {
		return ID_collezionista;
	}

	@Override
	public String toString() {
		return "Collection [ID=" + ID + ", nome=" + nome + ", visibilita=" + visibilita + ", ID_collezionista="
				+ ID_collezionista + "]";
	}
}