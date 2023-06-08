package it.univaq.disim.oop.collectors.domain;

public class Etichetta {

	private final Integer id;
	private String partitaIVA;
	private String nome;

	public Etichetta(Integer id, String partitaIVA, String nome) {
		super();
		this.id = id;
		this.partitaIVA = partitaIVA;
		this.nome = nome;
	}

	public String getPartitaIVA() {
		return partitaIVA;
	}

	public void setPartitaIVA(String partitaIVA) {
		this.partitaIVA = partitaIVA;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public Integer getId() {
		return id;
	}

	@Override
	public String toString() {
		return "Etichetta [id=" + id + ", partitaIVA=" + partitaIVA + ", nome=" + nome + "]";
	}

}
