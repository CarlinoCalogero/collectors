package it.univaq.disim.oop.collectors.business.JBCD;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.time.DateTimeException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Disco;
import it.univaq.disim.oop.collectors.domain.DiscoInCollezione;
import it.univaq.disim.oop.collectors.domain.Etichetta;
import it.univaq.disim.oop.collectors.domain.NumeroCollezioniDiCollezionista;
import it.univaq.disim.oop.collectors.domain.NumeroDischiPerGenere;
import it.univaq.disim.oop.collectors.domain.Track;

public class Query_JDBC {

	private Connection connection;
	private boolean supports_procedures;
	private boolean supports_function_calls;

	public Query_JDBC(Connection c) throws DatabaseConnectionException {
		connect(c);
	}

	public final void connect(Connection c) throws DatabaseConnectionException {
		this.connection = c;
		// verifichiamo quali comandi supporta il DBMS corrente
		supports_procedures = false;
		supports_function_calls = false;
		try {
			supports_procedures = connection.getMetaData().supportsStoredProcedures();
			supports_function_calls = supports_procedures
					&& connection.getMetaData().supportsStoredFunctionsUsingCallSyntax();
		} catch (SQLException ex) {
			Logger.getLogger(Query_JDBC.class.getName()).log(Level.SEVERE, null, ex);
		}
	}

	public Connection getConnection() {
		return this.connection;
	}

	public Collector login(String nickname, String email) throws DatabaseConnectionException {
		try (PreparedStatement s = connection
				.prepareStatement("select * from collezionista where email = ? and nickname = ?");) {
			s.setString(1, email);
			s.setString(2, nickname);
			try (ResultSet rs = s.executeQuery()) {
				if (rs.next())
					return new Collector(rs.getInt("id"), rs.getString("nickname"), rs.getString("email"));
			}
			return null;
		} catch (SQLException e) {
			throw new DatabaseConnectionException(e);
		}
	}

	public List<Collection> getCollections(Integer ID_collector) throws DatabaseConnectionException {

		List<Collection> collections = new ArrayList<>();

		try (PreparedStatement s = connection
				.prepareStatement("select * from collezione_di_dischi where ID_collezionista = ?");) {
			s.setInt(1, ID_collector);
			try (ResultSet rs = s.executeQuery()) {
				while (rs.next()) {
					collections.add(new Collection(rs.getInt("id"), rs.getString("nome"), rs.getBoolean("visibilita"),
							rs.getInt("ID_collezionista")));
				}
			}
			return collections;
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Login fallito", e);
		}
	}

	/*
	 * Implementazione della query 1.
	 */
	public void insertCollezione(Collection c) throws DatabaseConnectionException {
		// Se il db non supporta le procedure allora si esegue una semplice query di
		// inserimento
		if (!this.supports_procedures) {
			try (PreparedStatement query = connection.prepareStatement(
					"INSERT INTO collezione_di_dischi(nome,visibilita,id_collezionista)" + "VALUES(?,?,?);");) {
				query.setString(1, c.getNome());
				query.setBoolean(2, c.getVisibilita());
				query.setInt(3, c.getID_collezionista());
				query.execute();
			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
			return;
		}
		// Altrimenti si esegue la procedura creata e salvata nel db
		try (CallableStatement query = connection.prepareCall("{call insert_collezione(?,?,?)}");) {
			query.setString(2, c.getNome());
			query.setBoolean(3, c.getVisibilita());
			query.setInt(1, c.getID_collezionista());
			query.execute();
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Inserimento fallito", e);
		}
	}

	// Query 2_1
	public void aggiungiDiscoACollezione(Disco disco, int idCollezioneDiDischi) throws DatabaseConnectionException {
		// Se il db non supporta le procedure allora si esegue una semplice query di
		// inserimento
		if (!this.supports_procedures) {
			try (PreparedStatement query = connection.prepareStatement(
					"INSERT INTO disco(titolo,anno_di_uscita,nome_formato,nome_stato,id_etichetta,id_collezione_di_dischi)\n"
							+ "        VALUES (?,?,?,?,?,?);",
					new String[] { "ID" });
					PreparedStatement query2 = connection.prepareStatement("INSERT INTO info_disco VALUES (?,?,?,?);");
					PreparedStatement query3 = connection
							.prepareStatement("INSERT INTO classificazione VALUES (?,?);")) {

				if (disco.getAnnoDiUscita().isAfter(LocalDate.now())) {
					throw new DateTimeException("Errore! Data invalida");
				}
				connection.setAutoCommit(false);
				query.setString(1, disco.getTitolo());
				query.setDate(2, Date.valueOf(disco.getAnnoDiUscita()));
				query.setString(3, disco.getFormato());
				query.setString(4, disco.getStato());
				query.setInt(5, disco.getEtichetta().getId());
				query.setInt(6, idCollezioneDiDischi);
				query.execute();
				int lastInsertedId;
				ResultSet rs = query.getGeneratedKeys();
				// il controllo if(rs.next()) non è necessario perché se siamo arrivati qui
				// significa che l'inserimento è andato a buon fine
				rs.next();
				lastInsertedId = rs.getInt(1);
				query2.setInt(1, lastInsertedId);
				if (disco.getBarcode().equals(""))
					query2.setString(2, null);
				else
					query2.setString(2, disco.getBarcode());
				query2.setString(3, disco.getNote());
				query2.setInt(4, disco.getNumeroCopie());
				System.out.println("Query 2");
				query2.execute();
				// il controllo if(rs.next()) non è necessario perché se siamo arrivati qui
				// significa che l'inserimento è andato a buon fine
				for (String genere : disco.getGeneri()) {
					query3.setString(1, genere);
					query3.setInt(2, lastInsertedId);
					query3.execute();
				}
				connection.commit();
				connection.setAutoCommit(true);
			} catch (SQLException e) {
				try {
					String message = "Inserimento fallito";
					System.out.println("Rollback");
					connection.rollback();
					if (e instanceof SQLIntegrityConstraintViolationException)
						message = "Disco Duplicato";
					throw new DatabaseConnectionException(message, e);
				} catch (SQLException e1) {
					throw new DatabaseConnectionException("Errore nell'eseguire il rollback", e1);
				}
			}
		} else {
			// Altrimenti si esegue la procedura creata e salvata nel db
			try (CallableStatement query = connection
					.prepareCall("{call aggiungi_disco_a_collezione(?,?,?,?,?,?,?,?,?)}");
					PreparedStatement query2 = connection.prepareStatement("SELECT last_insert_id();");
					PreparedStatement query3 = connection
							.prepareStatement("INSERT INTO classificazione(nome_genere,id_disco) VALUES(?,?)")) {
				connection.setAutoCommit(false);
				query.setString(1, disco.getTitolo());
				query.setDate(2, Date.valueOf(disco.getAnnoDiUscita()));
				query.setString(3, disco.getFormato());
				query.setString(4, disco.getStato());
				query.setInt(5, disco.getEtichetta().getId());
				query.setInt(6, idCollezioneDiDischi);
				if (disco.getBarcode().equals(""))
					query.setString(7, null);
				else
					query.setString(7, disco.getBarcode());
				query.setString(8, disco.getNote());
				query.setInt(9, disco.getNumeroCopie());
				query.execute();
				ResultSet rs = query2.executeQuery();
				System.out.println(rs.next());
				int lastInsertedId = rs.getInt(1);
				for (String genere : disco.getGeneri()) {
					query3.setInt(2, lastInsertedId);
					query3.setString(1, genere);
					query3.execute();
				}
				connection.commit();
				connection.setAutoCommit(true);
			} catch (SQLException e) {
				try {
					String message = "Inserimento fallito";
					System.out.println("Rollback");
					connection.rollback();
					if (e instanceof SQLIntegrityConstraintViolationException)
						message = "Disco Duplicato";
					throw new DatabaseConnectionException(message, e);
				} catch (SQLException e1) {
					throw new DatabaseConnectionException("Errore nell'eseguire il rollback", e1);
				}
			}

		}

	}

	// Query 2_2
	public void aggiungiTracciaADisco(Track traccia) throws DatabaseConnectionException {
		// Se il db non supporta le procedure allora si esegue una semplice query di
		// inserimento
		if (!this.supports_procedures) {

			try (PreparedStatement query = connection.prepareStatement(
					"INSERT INTO traccia(titolo,durata,id_etichetta,id_disco) \r\n" + "    VALUES (?,?,?,?);")) {

				query.setString(1, traccia.getTitolo());
				query.setFloat(2, traccia.getDurata());
				query.setInt(3, traccia.getEtichetta().getId());
				query.setInt(4, traccia.getDisco().getId());
				query.execute();

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		} else {
			// Altrimenti si esegue la procedura creata e salvata nel db
			try (CallableStatement query = connection.prepareCall("{call aggiungi_traccia_a_disco(?,?,?,?)}");) {
				query.setString(1, traccia.getTitolo());
				query.setFloat(2, traccia.getDurata());
				query.setInt(3, traccia.getEtichetta().getId());
				query.setInt(4, traccia.getDisco().getId());
				query.execute();
			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		}
	}

	public List<Collector> getCollectors() throws DatabaseConnectionException {
		List<Collector> collectors = new ArrayList<>();
		try (PreparedStatement query = connection.prepareStatement("SELECT * FROM collezionista");) {
			try (ResultSet rs = query.executeQuery()) {
				while (rs.next()) {
					collectors.add(new Collector(rs.getInt("id"), rs.getString("nickname"), rs.getString("email")));
				}
				return collectors;
			}
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Condivisione Fallita", e);
		}
	}

	public List<Collector> getSharingOf(Collection collection) throws DatabaseConnectionException {

		List<Collector> sharingCollectors = new ArrayList<>();

		try (PreparedStatement query = connection
				.prepareStatement("" + "SELECT c.id,c.nickname,c.email \r\n" + "FROM condivisa con \r\n"
						+ "JOIN collezionista c on c.id=con.id_collezionista\r\n" + "WHERE id_collezione=?;");) {
			query.setInt(1, collection.getID());
			try (ResultSet rs = query.executeQuery()) {
				while (rs.next()) {
					sharingCollectors
							.add(new Collector(rs.getInt("id"), rs.getString("nickname"), rs.getString("email")));
				}
				return sharingCollectors;
			}

		} catch (SQLException e) {
			throw new DatabaseConnectionException("Condivisione Fallita", e);
		}
	}

	// Query 3_1
	public void insertCondivisione(Integer idColl, Collector c) throws DatabaseConnectionException {
		if (!this.supports_procedures) {
			throw new DatabaseConnectionException("Non si puo inserire senza procedure");
		}
		// Altrimenti si esegue la procedura creata e salvata nel db
		try (CallableStatement query = connection.prepareCall("{call inserisci_condivisione(?,?,?)}");) {
			query.setString(1, c.getNickname());
			query.setString(2, c.getEmail());
			query.setInt(3, idColl);
			query.execute();
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Condivisione Fallita", e);
		}
	}

	// Query 3
	public void switchVisibilita(Integer idCollection) throws DatabaseConnectionException {
		if (!this.supports_procedures) {
			try (PreparedStatement query = connection
					.prepareStatement("UPDATE collezione_di_dischi SET visibilita = ? WHERE id= ?;");
					PreparedStatement getVis = connection
							.prepareStatement("SELECT visibilita FROM collezione_di_dischi WHERE id = ?;");) {
				connection.setAutoCommit(false);
				boolean visibilita = false;
				getVis.setInt(1, idCollection);
				ResultSet vis = getVis.executeQuery();
				if (vis.next())
					visibilita = !vis.getBoolean("visibilita");
				query.setInt(2, idCollection);
				query.setBoolean(1, visibilita);
				query.execute();
				connection.commit();
				connection.setAutoCommit(true);
			} catch (SQLException e) {
				try {
					connection.rollback();
				} catch (SQLException e1) {
					throw new DatabaseConnectionException("Rollback fallito", e1);
				}
				throw new DatabaseConnectionException("Condivisione Fallita", e);
			}
			return;
		}
		// Altrimenti si esegue la procedura creata e salvata nel db
		try (CallableStatement query = connection.prepareCall("{call cambia_visibilita(?)}");) {
			query.setInt(1, idCollection);
			query.execute();
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Condivisione Fallita", e);
		}
	}

	// Query 4
	public void deleteDisco(Integer idDisco) throws DatabaseConnectionException {
		if (!this.supports_procedures) {
			try (PreparedStatement query = connection.prepareStatement("DELETE FROM disco WHERE id = ?;");) {
				query.setInt(1, idDisco);
				query.execute();
			} catch (SQLException e) {
				throw new DatabaseConnectionException("Rimozione Fallita", e);
			}
			return;
		}
		// Altrimenti si esegue la procedura creata e salvata nel db
		try (CallableStatement query = connection.prepareCall("{call rimuovi_disco(?)}");) {
			query.setInt(1, idDisco);
			query.execute();
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Rimozione Fallita", e);
		}
	}

	// Query 5
	public void deleteCollezione(Integer idCollection) throws DatabaseConnectionException {
		if (!this.supports_procedures) {
			try (PreparedStatement query = connection
					.prepareStatement("DELETE FROM collezione_di_dischi WHERE id=?;");) {
				query.setInt(1, idCollection);
				query.execute();
			} catch (SQLException e) {
				throw new DatabaseConnectionException("Rimozione Fallita", e);
			}
			return;
		}
		// Altrimenti si esegue la procedura creata e salvata nel db
		try (CallableStatement query = connection.prepareCall("{call rimuovi_collezione(?)}");) {
			query.setInt(1, idCollection);
			query.execute();
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Rimozione Fallita", e);
		}
	}

	// Query 6
	public ArrayList<Disco> getDischiInCollezione(Integer idCollection) throws DatabaseConnectionException {
		if (!this.supports_procedures) {
			String queryString = "SELECT d.id as \"ID\"," + "		   d.titolo as \"Titolo\","
					+ "		   d.anno_di_uscita as \"Anno di uscita\"," + "		   d.nome_stato as \"Stato\","
					+ "		   d.nome_formato as \"Formato\"," + "		   e.nome as \"Etichetta\","
					+ "           generi_disco(d.id) as \"Generi\"," + "           inf.barcode as \"Barcode\","
					+ "           inf.note as \"Note\"," + "           inf.numero_copie as \"Copie\""
					+ "	from disco d" + "    join etichetta e on d.id_etichetta = e.id"
					+ "    join info_disco inf on inf.id_disco = d.id"
					+ "    where d.id_collezione_di_dischi = id_collezione;";

			try (PreparedStatement query = connection.prepareStatement(queryString);) {
				query.setInt(1, idCollection);
				ResultSet result = query.executeQuery();
				ArrayList<Disco> dischi = new ArrayList<Disco>();
				while (result.next()) {
					Disco d = new Disco(result.getInt("ID"), result.getString("Titolo"),
							result.getDate("Anno di uscita").toLocalDate(), result.getString("Stato"),
							result.getString("Formato"), new Etichetta(null, null, result.getString("Etichetta")),
							result.getString("Generi").split(","), result.getString("Barcode"),
							result.getString("Note"), result.getInt("Copie"));
					dischi.add(d);
				}
				return dischi;
			} catch (SQLException e) {
				throw new DatabaseConnectionException("Selezione Dei dischi Fallita", e);
			}
		}
		// Altrimenti si esegue la procedura creata e salvata nel db
		try (CallableStatement query = connection.prepareCall("{call dischi_in_collezione(?)}");) {
			query.setInt(1, idCollection);
			ResultSet result = query.executeQuery();
			ArrayList<Disco> dischi = new ArrayList<Disco>();
			while (result.next()) {
				Disco d = new Disco(result.getInt("ID"), result.getString("Titolo"),
						result.getDate("Anno di uscita").toLocalDate(), result.getString("Stato"),
						result.getString("Formato"), new Etichetta(null, null, result.getString("Etichetta")),
						result.getString("Generi").split(", "), null, null, 1);
				dischi.add(d);
			}
			return dischi;
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Selezione Dei dischi Fallita", e);
		}
	}

	// Query 7
	public List<Track> getTrackList(Integer idDisco) throws DatabaseConnectionException {

		List<Track> tracce = new ArrayList<Track>();

		// Se il db non supporta le procedure allora si esegue una semplice query di
		// inserimento
		if (!this.supports_procedures) {

			try (PreparedStatement query = connection
					.prepareStatement("SELECT t.titolo,t.durata FROM traccia t WHERE t.id_disco=?;")) {

				query.setInt(1, idDisco);
				ResultSet result = query.executeQuery();

				while (result.next()) {
					Track dummyTrack = new Track(null, result.getString("titolo"), result.getFloat("durata"), null,
							null);
					tracce.add(dummyTrack);
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		} else {
			// Altrimenti si esegue la procedura creata e salvata nel db
			try (CallableStatement query = connection.prepareCall("{call track_list_disco(?)}");) {
				query.setInt(1, idDisco);
				ResultSet result = query.executeQuery();

				while (result.next()) {
					Track dummyTrack = new Track(null, result.getString("Titolo traccia"), result.getFloat("Durata"),
							null, null);
					tracce.add(dummyTrack);
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		}

		return tracce;
	}

	// Query 8
	public List<DiscoInCollezione> ricercaDiDischiConAutoreEOTitolo(String nomeDArte, String titolo,
			Integer idCollezionista, boolean collezioni, boolean condivise, boolean pubbliche)
			throws DatabaseConnectionException {
		List<DiscoInCollezione> dischi = new ArrayList<DiscoInCollezione>();

		// Se il db non supporta le procedure allora si esegue una semplice query di
		// inserimento
		if (!this.supports_procedures) {

			// piangi perché te la devi riscrivere a mano qui

		}
		// Altrimenti si esegue la procedura creata e salvata nel db
		try (CallableStatement query = connection
				.prepareCall("{call ricerca_di_dischi_con_autore_eo_titolo(?,?,?,?,?,?)}");) {
			query.setString(1, nomeDArte);
			if (titolo.equals(""))
				query.setString(2, null);
			else
				query.setString(2, titolo);
			query.setInt(3, idCollezionista);
			query.setBoolean(4, collezioni);
			query.setBoolean(5, condivise);
			query.setBoolean(6, pubbliche);
			ResultSet result = query.executeQuery();

			while (result.next()) {
				DiscoInCollezione dummyDisco = new DiscoInCollezione(null, result.getString("Titolo"),
						result.getDate("Anno di uscita").toLocalDate(), result.getString("Condizioni"),
						result.getString("Formato"), null, new String[1], null, null, 1, result.getString("Collezione"),
						result.getString("Proprietario"));
				dischi.add(dummyDisco);
			}

		} catch (SQLException e) {
			throw new DatabaseConnectionException("Inserimento fallito", e);
		}

		return dischi;
	}

	// Query 9
	public boolean verifica_visibilita_collezione(Integer idCollezione, Integer idCollezionista)
			throws DatabaseConnectionException {

		Boolean isVisible = false;

		// Se il db non supporta le procedure allora si esegue una semplice query di
		// inserimento
		if (!this.supports_procedures) {

			try (PreparedStatement query = connection
					.prepareStatement("(/* Verifica della visibiltà per collezioni personali */\r\n"
							+ "		SELECT cd.id as \"Visibilità\"\r\n" + "		FROM collezione_di_dischi cd\r\n"
							+ "		WHERE cd.id=?\r\n" + "		AND cd.id_collezionista=? \r\n"
							+ "	) UNION (/* Verifica della visibilità per collezioni pubbliche */\r\n"
							+ "		select cd.id as \"Visibilità\"\r\n" + "		from collezione_di_dischi as cd\r\n"
							+ "		where cd.id=?\r\n" + "			and cd.visibilita=true\r\n"
							+ "	) UNION (/* Verifica della visibilità per collezioni condivise */\r\n"
							+ "		SELECT c.id_collezione as \"Visibilità\"\r\n" + "		FROM condivisa c\r\n"
							+ "		WHERE c.id_collezione=?\r\n" + "		AND c.id_collezionista=?\r\n" + "	);")) {

				query.setInt(1, idCollezione);
				query.setInt(2, idCollezionista);
				query.setInt(3, idCollezione);
				query.setInt(4, idCollezione);
				query.setInt(5, idCollezionista);
				ResultSet result = query.executeQuery();

				while (result.next()) {
					if (result.getInt("Visibilità") > 0)
						isVisible = true;
				}
			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		} else {
			// Altrimenti si esegue la procedura creata e salvata nel db
			try (CallableStatement query = connection.prepareCall("{call verifica_visibilita_collezione(?,?)}");) {
				query.setInt(1, idCollezione);
				query.setInt(2, idCollezionista);
				ResultSet result = query.executeQuery();

				while (result.next()) {
					if (result.getInt("Visibilità") > 0)
						isVisible = true;
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		}

		return isVisible;

	}

	// Query 10
	public int getNumberOfTracks(String nomeArte) throws DatabaseConnectionException {
		String queryString = "SELECT count(distinct t.id) as 'conta'" + "		FROM autore a"
				+ "		JOIN produce p ON p.id_autore=a.id" + "		JOIN traccia t ON t.id=p.id_traccia"
				+ "		JOIN disco d ON d.id=t.id_disco"
				+ "		JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi" + "		WHERE c.visibilita=true"
				+ "		AND a.nome_darte LIKE ?" + "		GROUP BY a.id);";
		if (this.supports_function_calls)
			queryString = "SELECT conta_brani(?) as 'conta';";
		try (PreparedStatement query = connection.prepareStatement(queryString);) {
			query.setString(1, nomeArte);
			ResultSet result = query.executeQuery();
			if (result.next())
				return result.getInt("conta");
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Selezione Dei dischi Fallita", e);
		}
		return 0;
	}

	// Query 11
	public float contaMinutiAutore(String nomeDArte) throws DatabaseConnectionException {

		float minutiTotaliAutore = 0;

		// Se il db non supporta le procedure allora si esegue una semplice query di
		// inserimento
		if (!this.supports_procedures) {

			try (PreparedStatement query = connection.prepareStatement("SELECT sum(distinct t.durata) as 'conta'"
					+ "		FROM autore a\r\n" + "		JOIN produce p ON p.id_autore=a.id\r\n"
					+ "		JOIN traccia t ON t.id=p.id_traccia\r\n" + "		JOIN disco d ON d.id=t.id_disco\r\n"
					+ "		JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi\r\n"
					+ "		WHERE c.visibilita=true \r\n" + "		AND a.nome_darte=?\r\n" + "		GROUP BY a.id);")) {

				query.setString(1, nomeDArte);
				ResultSet result = query.executeQuery();

				while (result.next()) {
					minutiTotaliAutore = result.getFloat("conta");
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		} else {
			// Altrimenti si esegue la procedura creata e salvata nel db
			try (PreparedStatement query = connection.prepareStatement("select conta_minuti_autore(?) as 'conta';")) {

				query.setString(1, nomeDArte);
				ResultSet result = query.executeQuery();

				while (result.next()) {
					minutiTotaliAutore = result.getFloat("conta");
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		}

		return minutiTotaliAutore;

	}

	// Query 12_1
	public List<NumeroCollezioniDiCollezionista> contaCollezioni() throws DatabaseConnectionException {

		List<NumeroCollezioniDiCollezionista> listaCollezioni = new ArrayList<NumeroCollezioniDiCollezionista>();

		// Se il db non supporta le procedure allora si esegue una semplice query di
		// inserimento
		if (!this.supports_procedures) {

			try (PreparedStatement query = connection.prepareStatement("SELECT c.nickname as \"Collezionista\" , \r\n"
					+ "		   count(cd.id) as \"Numero di Collezioni\"\r\n" + "    FROM collezione_di_dischi cd\r\n"
					+ "	RIGHT JOIN collezionista c ON cd.id_collezionista=c.id\r\n" + "    GROUP BY c.nickname\r\n"
					+ "    ORDER BY Collezionista ASC;")) {

				ResultSet result = query.executeQuery();

				while (result.next()) {
					listaCollezioni.add(new NumeroCollezioniDiCollezionista(result.getString("Collezionista"),
							result.getInt("Numero di Collezioni")));
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		} else {
			// Altrimenti si esegue la procedura creata e salvata nel db
			try (CallableStatement query = connection.prepareCall("{call conta_collezioni()}");) {

				ResultSet result = query.executeQuery();

				while (result.next()) {
					listaCollezioni.add(new NumeroCollezioniDiCollezionista(result.getString("Collezionista"),
							result.getInt("Numero di Collezioni")));
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		}

		return listaCollezioni;

	}

	// Query 12_2
	public List<NumeroDischiPerGenere> contaDischiPerGenere() throws DatabaseConnectionException {

		List<NumeroDischiPerGenere> numeroDischi = new ArrayList<NumeroDischiPerGenere>();

		// Se il db non supporta le procedure allora si esegue una semplice query di
		// inserimento
		if (!this.supports_procedures) {

			try (PreparedStatement query = connection.prepareStatement("SELECT c.nome_genere as \"Genere\" , \r\n"
					+ "		   count(c.id_disco) as \"Numero di Dischi\"\r\n" + "    FROM classificazione c\r\n"
					+ "    GROUP BY c.nome_genere;")) {

				ResultSet result = query.executeQuery();

				while (result.next()) {
					numeroDischi.add(
							new NumeroDischiPerGenere(result.getString("Genere"), result.getInt("Numero di Dischi")));
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		} else {
			// Altrimenti si esegue la procedura creata e salvata nel db
			try (CallableStatement query = connection.prepareCall("{call conta_dischi_per_genere()}");) {

				ResultSet result = query.executeQuery();

				while (result.next()) {
					numeroDischi.add(
							new NumeroDischiPerGenere(result.getString("Genere"), result.getInt("Numero di Dischi")));
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		}

		return numeroDischi;

	}

	// Query 13
	public List<DiscoInCollezione> cercaDischiInCollezioni(String barcode, String titolo, String nomeDArte)
			throws DatabaseConnectionException {

		List<DiscoInCollezione> dischiInCollezione = new ArrayList<DiscoInCollezione>();

		if (barcode != null) {

			try (PreparedStatement query = connection.prepareStatement(
					"select d.titolo, d.anno_di_uscita, d.nome_formato, d.nome_stato, cd.nome, ca.nickname\r\n"
							+ "from info_disco as i \r\n" + "	join disco as d on d.id=i.id_disco \r\n"
							+ "    join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id\r\n"
							+ "    join collezionista as ca on cd.id_collezionista = ca.id\r\n"
							+ "where i.barcode=?;")) {

				query.setString(1, barcode);
				ResultSet result = query.executeQuery();

				while (result.next()) {
					dischiInCollezione.add(new DiscoInCollezione(null, result.getString("titolo"),
							result.getDate("anno_di_uscita").toLocalDate(), result.getString("nome_stato"),
							result.getString("nome_formato"), null, new String[1], null, null, 1,
							result.getString("nome"), result.getString("nickname")));
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}

		} else {

			List<DiscoInCollezione> dischiInCollezioneByTitolo = new ArrayList<DiscoInCollezione>();

			if (titolo != null) {
				try (PreparedStatement query = connection.prepareStatement(
						"select d.titolo, d.anno_di_uscita, d.nome_formato, d.nome_stato, cd.nome, ca.nickname\r\n"
								+ "from disco as d\r\n"
								+ "	join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id\r\n"
								+ "	join collezionista as ca on cd.id_collezionista = ca.id\r\n"
								+ "where d.titolo like concat(?,'%');")) {

					query.setString(1, titolo);
					ResultSet result = query.executeQuery();

					while (result.next()) {
						dischiInCollezione.add(new DiscoInCollezione(null, result.getString("titolo"),
								result.getDate("anno_di_uscita").toLocalDate(), result.getString("nome_stato"),
								result.getString("nome_formato"), null, new String[1], null, null, 1,
								result.getString("nome"), result.getString("nickname")));
					}

					Collections.sort(dischiInCollezioneByTitolo, new StringByLengthComparator(titolo, null));

				} catch (SQLException e) {
					throw new DatabaseConnectionException("Inserimento fallito", e);
				}

			}

			List<DiscoInCollezione> dischiInCollezioneByAutore = new ArrayList<DiscoInCollezione>();
			if (nomeDArte != null) {
				try (PreparedStatement query = connection.prepareStatement(
						"select d.titolo, d.anno_di_uscita, d.nome_formato, d.nome_stato, cd.nome, ca.nickname\r\n"
								+ "from incide as i\r\n" + "	join disco as d on i.id_disco=d.id\r\n"
								+ "    join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id\r\n"
								+ "    join collezionista as ca on cd.id_collezionista = ca.id\r\n"
								+ "	join autore as a on i.id_autore=a.id\r\n"
								+ "where a.nome_darte like concat(?,'%');")) {

					query.setString(1, nomeDArte);
					ResultSet result = query.executeQuery();

					while (result.next()) {
						dischiInCollezione.add(new DiscoInCollezione(null, result.getString("titolo"),
								result.getDate("anno_di_uscita").toLocalDate(), result.getString("nome_stato"),
								result.getString("nome_formato"), null, new String[1], null, null, 1,
								result.getString("nome"), result.getString("nickname")));
					}

					Collections.sort(dischiInCollezioneByAutore, new StringByLengthComparator(null, nomeDArte));

				} catch (SQLException e) {
					throw new DatabaseConnectionException("Inserimento fallito", e);
				}

			}

			List<DiscoInCollezione> dischiInCollezioneByTitoloAndByAutore = new ArrayList<DiscoInCollezione>();
			if (titolo != null & nomeDArte != null) {

				try (PreparedStatement query = connection.prepareStatement("select *\r\n" + "from incide as i\r\n"
						+ "	join disco as d on i.id_disco=d.id\r\n"
						+ "    join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id\r\n"
						+ "    join collezionista as ca on cd.id_collezionista = ca.id\r\n"
						+ "	join autore as a on i.id_autore=a.id\r\n" + "where a.nome_darte like concat(?,'%')\r\n"
						+ "	and d.titolo like concat(?,'%');")) {

					query.setString(1, titolo);
					query.setString(2, nomeDArte);
					ResultSet result = query.executeQuery();

					while (result.next()) {
						dischiInCollezione.add(new DiscoInCollezione(null, result.getString("titolo"),
								result.getDate("anno_di_uscita").toLocalDate(), result.getString("nome_stato"),
								result.getString("nome_formato"), null, new String[1], null, null, 1,
								result.getString("nome"), result.getString("nickname")));
					}

					Collections.sort(dischiInCollezioneByTitoloAndByAutore,
							new StringByLengthComparator(titolo, nomeDArte));

				} catch (SQLException e) {
					throw new DatabaseConnectionException("Inserimento fallito", e);
				}

			}

			if (!dischiInCollezioneByTitoloAndByAutore.isEmpty())
				dischiInCollezione.addAll(dischiInCollezioneByTitoloAndByAutore);
			if (!dischiInCollezioneByTitolo.isEmpty())
				dischiInCollezione.addAll(dischiInCollezioneByTitolo);
			if (!dischiInCollezioneByAutore.isEmpty())
				dischiInCollezione.addAll(dischiInCollezioneByAutore);

		}

		return dischiInCollezione;
	}

	// Comparator class for query 13
	private class StringByLengthComparator implements Comparator<DiscoInCollezione> {

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

	public List<String> getStates() throws DatabaseConnectionException {
		List<String> states = new ArrayList<>();

		try (PreparedStatement query = connection.prepareStatement("SELECT * FROM collectors.stato s;");) {
			try (ResultSet rs = query.executeQuery()) {
				while (rs.next()) {
					states.add(rs.getString("nome"));
				}
				return states;
			}

		} catch (SQLException e) {
			throw new DatabaseConnectionException(e);
		}
	}

	public List<String> getFormats() throws DatabaseConnectionException {
		List<String> formats = new ArrayList<>();
		try (PreparedStatement query = connection.prepareStatement("SELECT * FROM collectors.formato;");) {
			try (ResultSet rs = query.executeQuery()) {
				while (rs.next()) {
					formats.add(rs.getString("nome"));
				}
				return formats;
			}

		} catch (SQLException e) {
			throw new DatabaseConnectionException(e);
		}
	}

	public List<String> getGenras() throws DatabaseConnectionException {
		List<String> genras = new ArrayList<>();

		try (PreparedStatement query = connection.prepareStatement("SELECT g.nome FROM collectors.genere g;");) {
			try (ResultSet rs = query.executeQuery()) {
				while (rs.next()) {
					genras.add(rs.getString("nome"));
				}
				return genras;
			}

		} catch (SQLException e) {
			throw new DatabaseConnectionException(e);
		}
	}

	public List<Etichetta> getEtichette() throws DatabaseConnectionException {
		List<Etichetta> etichette = new ArrayList<>();

		try (PreparedStatement query = connection.prepareStatement("SELECT * FROM collectors.etichetta e;");) {
			try (ResultSet rs = query.executeQuery()) {
				while (rs.next()) {
					etichette.add(new Etichetta(rs.getInt("ID"), rs.getString("partitaIVA"), rs.getString("nome")));
				}
				return etichette;
			}

		} catch (SQLException e) {
			throw new DatabaseConnectionException(e);
		}
	}
}
