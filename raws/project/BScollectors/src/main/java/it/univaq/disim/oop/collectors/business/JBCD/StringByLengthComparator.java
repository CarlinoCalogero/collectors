package it.univaq.disim.oop.collectors.business.JBCD;

import java.util.Comparator;

import it.univaq.disim.oop.collectors.domain.DiscoInCollezione;

// Comparator class for query 
public class StringByLengthComparator implements Comparator<DiscoInCollezione> {

	private Integer referenceLengthTitolo;
	private Integer referenceLengthNomeDarte;

	public StringByLengthComparator(String referenceTitolo, String referenceNomeDArte) {
		super();
		if (referenceTitolo != null)
			this.referenceLengthTitolo = referenceTitolo.length();
		if (referenceNomeDArte != null)
			this.referenceLengthNomeDarte = referenceNomeDArte.length();
	}

	private int customCompare(DiscoInCollezione s1, DiscoInCollezione s2, int referenceLength) {
		int dist1 = Math.abs(s1.getTitolo().length() - referenceLength);
		int dist2 = Math.abs(s2.getTitolo().length() - referenceLength);

		return dist1 - dist2;
	}

	public int compare(DiscoInCollezione s1, DiscoInCollezione s2) {

		if (this.referenceLengthTitolo != null && referenceLengthNomeDarte == null) {
			return customCompare(s1, s2, this.referenceLengthTitolo);
		}

		if (this.referenceLengthTitolo == null && referenceLengthNomeDarte != null) {
			return customCompare(s1, s2, this.referenceLengthNomeDarte);
		}

		if (this.referenceLengthTitolo != null && referenceLengthNomeDarte != null) {
			int diffTitolo = customCompare(s1, s2, this.referenceLengthTitolo);
			int diffAutore = customCompare(s1, s2, this.referenceLengthNomeDarte);

			if (diffTitolo >= diffAutore) {
				return diffAutore;
			} else {
				return diffTitolo;
			}
		}

		// this.referenceLengthTitolo == null && referenceLengthNomeDarte == null
		if (s1.getTitolo().length() > s2.getTitolo().length()) {
			return 1;
		} else if (s1.getTitolo().length() < s2.getTitolo().length()) {
			return -1;
		}
		// s1.getTitolo().length() == s2.getTitolo().length()
		return 0;

	}
}