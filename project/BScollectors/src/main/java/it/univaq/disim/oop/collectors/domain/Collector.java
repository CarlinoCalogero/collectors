package it.univaq.disim.oop.collectors.domain;

public class Collector {
	
	public final Integer ID;
	public final String nickname;
	public final String email;
	
	public Collector(Integer ID, String nickname, String email) {
		this.ID = ID;
		this.nickname = nickname;
		this.email = email;
	}
}
