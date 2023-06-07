package it.univaq.disim.oop.collectors.domain;

public class Collector {
	
	private final Integer ID;
	private final String nickname;
	private final String email;
	
	public Collector(Integer ID, String nickname, String email) {
		this.ID = ID;
		this.nickname = nickname;
		this.email = email;
	}

	public Integer getID() {
		return ID;
	}

	public String getNickname() {
		return nickname;
	}

	public String getEmail() {
		return email;
	}
	
	@Override
	public boolean equals(Object obj) {
		if(obj == null || !(obj instanceof Collector)) return false;
		Collector c = (Collector)obj;
		return this.ID == c.ID;
	}
}
