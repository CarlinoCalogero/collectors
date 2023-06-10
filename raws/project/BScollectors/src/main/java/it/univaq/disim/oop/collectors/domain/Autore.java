package it.univaq.disim.oop.collectors.domain;

public class Autore {

	private final Integer id;
	private final String nomedarte;
	private final TipoAutore tipoAutore;

	public Autore(Integer id, String nomedarte, TipoAutore tipoAutore) {
		super();
		this.id = id;
		this.nomedarte = nomedarte;
		this.tipoAutore = tipoAutore;
	}

	public Integer getId() {
		return id;
	}

	public String getNomedarte() {
		return nomedarte;
	}

	public TipoAutore getTipoAutore() {
		return tipoAutore;
	}

}
