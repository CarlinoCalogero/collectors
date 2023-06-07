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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import it.univaq.disim.oop.collectors.domain.Collection;
import it.univaq.disim.oop.collectors.domain.Collector;
import it.univaq.disim.oop.collectors.domain.Disco;
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
	public void insertDiscoACollezione(Disco disco, int idCollezioneDiDischi) throws DatabaseConnectionException {
		// Se il db non supporta le procedure allora si esegue una semplice query di
		// inserimento
		if (!this.supports_procedures) {

			try (PreparedStatement query = connection.prepareStatement(
					"INSERT INTO disco(titolo,anno_di_uscita,nome_formato,nome_stato,id_etichetta,id_collezione_di_dischi)\n"
							+ "        VALUES (?,?,?,?,?,?);")) {
				if (disco.getAnnoDiUscita().isAfter(LocalDate.now())) {
					throw new DateTimeException("Errore! Data invalida");
				}
				query.setString(1, disco.getTitolo());
				query.setDate(2, Date.valueOf(disco.getAnnoDiUscita()));
				query.setString(3, disco.getFormato());
				query.setString(4, disco.getStato());
				query.setInt(5, disco.getEtichetta().getId());
				query.setInt(6, idCollezioneDiDischi);

				try {
					query.execute();
				} catch (SQLIntegrityConstraintViolationException e) {
					throw new SQLIntegrityConstraintViolationException(
							"Il disco risulta essere già inserito nella collezione", e);
				}

				try (PreparedStatement query2 = connection
						.prepareStatement("INSERT INTO info_disco VALUES (?,?,?,?);")) {

					ResultSet rs = query.getGeneratedKeys();
					// il controllo if(rs.next()) non è necessario perché se siamo arrivati qui
					// significa che l'inserimento è andato a buon fine
					rs.next();
					int lastInsertedId = rs.getInt(1);
					query2.setInt(1, lastInsertedId);
					query2.setString(2, disco.getBarcode());
					query2.setString(3, disco.getNote());
					query2.setInt(4, disco.getNumeroCopie());
					query2.execute();
				} catch (SQLException e) {
					throw new DatabaseConnectionException("Inserimento fallito", e);
				}

			} catch (SQLException e) {
				throw new DatabaseConnectionException("Inserimento fallito", e);
			}
		}
		// Altrimenti si esegue la procedura creata e salvata nel db
		try (CallableStatement query = connection
				.prepareCall("{call aggiungi_disco_a_collezione(?,?,?,?,?,?,?,?,?)}");) {
			query.setString(1, disco.getTitolo());
			query.setDate(2, Date.valueOf(disco.getAnnoDiUscita()));
			query.setString(3, disco.getFormato());
			query.setString(4, disco.getStato());
			query.setInt(5, disco.getEtichetta().getId());
			query.setInt(6, idCollezioneDiDischi);
			query.setString(7, disco.getBarcode());
			query.setString(8, disco.getNote());
			query.setInt(9, disco.getNumeroCopie());
			query.execute();
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Inserimento fallito", e);
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
					+ "           generi_disco(d.id) as \"Generi\"" + "	from disco d"
					+ "    join etichetta e on d.id_etichetta = e.id" + "    where d.id_collezione_di_dischi = ?;";

			try (PreparedStatement query = connection.prepareStatement(queryString);) {
				query.setInt(1, idCollection);
				ResultSet result = query.executeQuery();
				ArrayList<Disco> dischi = new ArrayList<Disco>();
				while (result.next()) {
					Disco d = new Disco(result.getInt("ID"), result.getString("Titolo"),
							result.getDate("Anno di uscita").toLocalDate(), result.getString("Stato"),
							result.getString("Formato"), result.getString("Etichetta"),
							result.getString("Generi").split(","));
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
						result.getString("Formato"), result.getString("Etichetta"),
						result.getString("Generi").split(","));
				dischi.add(d);
			}
			return dischi;
		} catch (SQLException e) {
			throw new DatabaseConnectionException("Selezione Dei dischi Fallita", e);
		}
	}

	// Query 7
	public List<Track> getTrackList(Disco d) {

		List<Track> tracks = new ArrayList<>();

		return tracks;
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
	/*
	 * ESEMPIO 1: esecuzione diretta di query e lettura dei risultati public void
	 * classifica_marcatori(int anno) throws ApplicationException {
	 * System.out.println("CLASSIFICA MARCATORI " + anno +
	 * "-----------------------"); //eseguiamo la query //notare che creiamo lo
	 * statement e il resultset in un try-with-resources try ( Statement s =
	 * connection.createStatement(); //attenzione: in generale sarebbe meglio
	 * scrivere le stringhe di SQL //sotto forma di costanti (ad esempio a livello
	 * classe) e riferirvisi //solo nel codice, per una migliore mantenibilità dei
	 * sorgenti ResultSet rs = s.
	 * executeQuery("select g.cognome,g.nome, s.nome as squadra, count(*) as punti from\n"
	 * + "giocatore g \n" + "	join segna m on (m.ID_giocatore=g.ID)\n" +
	 * "	join partita p on (p.ID=m.ID_partita) \n" +
	 * "	join campionato c on (p.ID_campionato=c.ID)\n" +
	 * "	join formazione f on (f.ID_giocatore=g.ID)\n" +
	 * "	join squadra s on (s.ID=f.ID_squadra)\n" +
	 * "where (c.anno=f.anno) and c.anno=" + anno + " \n" +
	 * "group by g.cognome,g.nome, s.nome\n" + "order by punti desc;");
	 * //PERICOLOSO! Usiamo sempre i PreparedStatement! ) { //iteriamo nella lista
	 * di record risultanti while (rs.next()) { //stampiamo le varie colonne di
	 * ciascun record, prelevandole col tipo corretto
	 * System.out.print(rs.getString("nome")); System.out.print("\t" +
	 * rs.getString("cognome")); System.out.print("\t" + rs.getString("squadra"));
	 * System.out.println("\t" + rs.getInt("punti")); } } catch (SQLException ex) {
	 * throw new ApplicationException("Errore di esecuzione della query", ex); } //s
	 * e rs vengono chiusi automaticamente dal try-with-resources }
	 * 
	 * //ESEMPIO 2: esecuzione di query precompilata con passaggio parametri public
	 * void calendario_campionato(int anno) throws ApplicationException {
	 * System.out.println("CALENDARIO CAMPIONATO " + anno +
	 * "----------------------"); //un oggetto-formattatore per le date DateFormat
	 * df = new SimpleDateFormat("dd/MM/yyyy"); //precompiliamo la query try (
	 * PreparedStatement s = connection.
	 * prepareStatement("select s1.nome as squadra1,s2.nome as squadra2,p.data\n" +
	 * "from campionato c join partita p on (p.ID_campionato=c.ID) join squadra s1 on (p.ID_squadra_1 = s1.ID) join squadra s2 on (p.ID_squadra_2 = s2.ID)\n"
	 * + "where c.anno=?\n" + "order by p.data asc;")) { //impostiamo i parametri
	 * della query s.setInt(1, anno); //eseguiamo la query //questo
	 * try-with-resources senza catch garantisce la chisura di rs al termine del suo
	 * uso try ( ResultSet rs = s.executeQuery()) { //iteriamo nella lista di record
	 * risultanti while (rs.next()) { //stampiamo le varie colonne di ciascun
	 * record, prelevandole col tipo corretto
	 * System.out.print(rs.getString("squadra1")); System.out.print("\t" +
	 * rs.getString("squadra2")); //una colonna DATE viene estratta con il tipo Java
	 * java.sql.Date, una sottoclasse di java.util.Date System.out.println("\t" +
	 * df.format(rs.getDate("data"))); } } } catch (SQLException ex) { throw new
	 * ApplicationException("Errore di esecuzione della query", ex); } }
	 * 
	 * //ESEMPIO 3: esecuzione di query di inserimento public void
	 * inserisci_partita(Date data, int ID_campionato, int ID_squadra_1, int
	 * ID_squadra_2, int ID_luogo) throws ApplicationException {
	 * System.out.println("INSERIMENTO PARTITA " + ID_squadra_1 + "-" + ID_squadra_2
	 * + "---------------------------"); //precompiliamo la query //il parametro
	 * extra dice al driver dove trovare la chiave auto-generata del nuovo record
	 * try ( PreparedStatement s = connection.
	 * prepareStatement("insert into partita(ID_campionato, data,ID_squadra_1,ID_squadra_2,ID_luogo) values(?,?,?,?,?)"
	 * , new String[]{"ID"})) { //impostiamo i parametri della query s.setInt(1,
	 * ID_campionato); //la java.util.Date va convertita in java.sql.Timestamp
	 * (data+ora) o java.sql.Date (solo data) s.setTimestamp(2, new
	 * java.sql.Timestamp(data.getTime())); s.setInt(3, ID_squadra_1); s.setInt(4,
	 * ID_squadra_2); s.setInt(5, ID_luogo); //eseguiamo la query int affected =
	 * s.executeUpdate(); //stampiamo il numero di record inseriti
	 * System.out.println("record inseriti: " + affected); //volendo estrarre la
	 * chiave auto-generata per i record inseriti... try ( ResultSet rs =
	 * s.getGeneratedKeys()) { while (rs.next()) { //stampiamo le chiavi (i record
	 * hanno tante colonne quante sono //le colonne specificate nel secondo
	 * parametro della prepareStatement) System.out.println("chiave generata: " +
	 * rs.getInt(1)); } } } catch (SQLException ex) { throw new
	 * ApplicationException("Errore di esecuzione della query", ex); } }
	 * 
	 * //ESEMPIO 4: esecuzione di query di aggiornamento public void
	 * aggiorna_partita(int ID_partita, int punti_squadra_1, int punti_squadra_2)
	 * throws ApplicationException { System.out.println("AGGIORNAMENTO PARTITA " +
	 * ID_partita + "-------------------------"); //precompiliamo la query try (
	 * PreparedStatement s = connection.
	 * prepareStatement("update partita set punti_squadra_1=?, punti_squadra_2=? where ID=?"
	 * )) { //impostiamo i parametri della query s.setInt(1, punti_squadra_1);
	 * s.setInt(2, punti_squadra_2); s.setInt(3, ID_partita); //eseguiamo la query
	 * int affected = s.executeUpdate(); //stampiamo il numero di record modificati
	 * System.out.println("record modificati: " + affected); } catch (SQLException
	 * ex) { throw new ApplicationException("Errore di esecuzione della query", ex);
	 * } }
	 * 
	 * //ESEMPIO 5: chiamata a procedura con parametri IN e generazione di un
	 * ResultSet public void formazione(int ID_squadra, int anno) throws
	 * ApplicationException { System.out.println("FORMAZIONE " + anno + " SQUADRA "
	 * + ID_squadra + "-----------------------"); //precompiliamo la chiamata a
	 * procedura (con parametro) //notare la sintassi speciale da usare per le
	 * chiamate a procedura if (supports_procedures) { try ( CallableStatement s =
	 * connection.prepareCall("{call formazione(?,?)}")) { //impostiamo i parametri
	 * della chiamata s.setInt(1, ID_squadra); s.setInt(2, anno); //eseguiamo la
	 * chiamata s.execute(); //leggiamo la tabella generata dalla chiamata try (
	 * ResultSet rs = s.getResultSet()) { while (rs.next()) {
	 * System.out.print(rs.getString(1)); System.out.print("\t" + rs.getString(2));
	 * System.out.println("\t" + rs.getString(3)); } } } catch (SQLException ex) {
	 * throw new ApplicationException("Errore di esecuzione della query", ex); } }
	 * else { System.out.println("** NON SUPPORTATO **"); } }
	 * 
	 * //ESEMPIO 6: chimata a procedura con parametri IN e OUT public void
	 * squadra_appartenenza(int ID_giocatore, int anno) throws ApplicationException
	 * { System.out.println("SQUADRA GIOCATORE " + ID_giocatore + " NEL " + anno +
	 * "--------------------"); //precompiliamo la chiamata a procedura (con
	 * parametri) if (supports_procedures) { try ( CallableStatement s =
	 * connection.prepareCall("{call squadra_appartenenza(?,?,?)}")) { //impostiamo
	 * i parametri IN della chiamata s.setInt(1, ID_giocatore); s.setInt(2, anno);
	 * //registriamo i parametri OUT della chiamata (con tipo)
	 * s.registerOutParameter(3, Types.VARCHAR); //eseguiamo la chiamata
	 * s.execute(); //leggiamo il valore del parametro OUT
	 * System.out.println(s.getString(3)); } catch (SQLException ex) { throw new
	 * ApplicationException("Errore di esecuzione della query", ex); } } else {
	 * System.out.println("** NON SUPPORTATO **"); } }
	 * 
	 * //ESEMPIO 7: chimata a funzione public void controlla_partita(int ID_partita)
	 * throws ApplicationException {
	 * 
	 * System.out.println("CONTROLLO PARTITA " + ID_partita +
	 * "-----------------------------"); if (supports_procedures &&
	 * supports_function_calls) { //precompiliamo la chiamata a funzione try (
	 * CallableStatement s =
	 * connection.prepareCall("{?  = call controlla_partita(?)}")) { //impostiamo i
	 * parametri della chiamata s.setInt(2, ID_partita); //registriamo il valore
	 * della funzione come fosse un parametro OUT della chiamata (con tipo)
	 * s.registerOutParameter(1, Types.VARCHAR); //eseguiamo la chiamata
	 * s.execute(); //leggiamo il valore del parametro OUT
	 * System.out.println(s.getString(1)); } catch (SQLException ex) { throw new
	 * ApplicationException("Errore di esecuzione della query", ex); } } else {
	 * System.out.println("** NON SUPPORTATO **"); } }
	 */
}
