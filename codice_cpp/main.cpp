#include <cstdio>
#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h"
#define PG_HOST "localhost"
#define PG_USER "postgres"
#define PG_DB "SecureNet"
#define PG_PASS "q"
#define PG_PORT 5432
using namespace std;

PGconn *connect();
void checkResults(PGresult *res, const PGconn *conn);
void StampaMenu();
void fill_query(string *QueryArray);
PGresult *ParamQuery(PGconn *conn, string QueryArray[], int QueryNumber);
void StampaRisultati(PGresult *res);
void printLine(int campi, const int *maxLen);

int main(int argc, char **argv)
{
    PGconn *conn = connect();
    string *query = new string[7];
    fill_query(query);
    int sel = 0;
    do
    {
        StampaMenu();
        PGresult *res = NULL;
        cin >> sel;
        if (sel != 0)
        {
            switch (sel)
            {
            case 0:
                break;
            case 1:
                cout << "Inserisci spesa minima" << endl;
                res = ParamQuery(conn, query, sel);
                break;
            case 2:
                res = PQexec(conn, query[sel - 1].c_str());
                break;
            case 3:
                res = PQexec(conn, query[sel - 1].c_str());
                break;
            case 4:
                res = PQexec(conn, query[sel - 1].c_str());
                break;
            case 5:
                res = PQexec(conn, query[sel - 1].c_str());
                break;
            case 6:
                cout << "Inserisci anno" << endl;
                res = ParamQuery(conn, query, sel);
                break;
            case 7:
                res = PQexec(conn, query[sel - 1].c_str());
                break;
            }
            checkResults(res, conn);
            StampaRisultati(res);
            PQclear(res);
        }

    } while (sel != 0);
    return 0;
}

PGresult *ParamQuery(PGconn *conn, string QueryArray[], int QueryNumber)
{
    char QueryName[10];
    sprintf(QueryName, "Query %d", QueryNumber);
    PQprepare(conn, QueryName, QueryArray[QueryNumber - 1].c_str(), 1, NULL);
    string parameter;
    cin >> parameter;
    const char *param = parameter.c_str();
    return PQexecPrepared(conn, QueryName, 1, &param, NULL, 0, 0);
}

PGconn *connect()
{
    char conninfo[250];
    sprintf(conninfo, " user =%s password =%s dbname =%s host =%s port =%d ", PG_USER, PG_PASS, PG_DB, PG_HOST, PG_PORT);
    PGconn *conn;
    conn = PQconnectdb(conninfo);
    if (PQstatus(conn) != CONNECTION_OK)
    {
        cout << "Errore di connessione" << PQerrorMessage(conn) << endl;
        PQfinish(conn);
        exit(1);
    }
    cout << "Connessione avvenuta correttamente" << endl;
    return conn;
}

void checkResults(PGresult *res, const PGconn *conn)
{
    if (PQresultStatus(res) != PGRES_TUPLES_OK)
    {
        cout << "Risultati inconsistenti!" << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }
}

void fill_query(string *QueryArray)
{
    QueryArray[0] = "SELECT c.Email\n"
                    "FROM Cliente c JOIN Sottoscrizione s ON c.Email = s.Cliente JOIN Antivirus a ON s.Antivirus = a.Versione LEFT JOIN Recensione r ON c.Email = r.Cliente AND a.Versione = r.Antivirus\n"
                    "GROUP BY c.email, c.nome, c.cognome, a.prezzo_mensile, r.id \n"
                    "HAVING a.Prezzo_Mensile * 12 > $1::integer AND r.ID IS NULL";
    QueryArray[1] = "SELECT a.Versione AS Antivirus, COUNT(DISTINCT s.Cliente) AS NumeroSottoscrizioni, ROUND(AVG(r.Voto),1) AS MediaVoti\n"
                    "FROM Antivirus a\n"
                    "LEFT JOIN Sottoscrizione s ON a.Versione = s.Antivirus LEFT JOIN Recensione r ON a.Versione = r.Antivirus\n"
                    "GROUP BY a.Versione\n"
                    "ORDER BY NumeroSottoscrizioni DESC\n";
    QueryArray[2] = "SELECT P.Cognome, P.Nome, COUNT(L.ID) AS NumeroProgetti\n"
                    "FROM Professionista P\n"
                    "JOIN Lavoro L ON P.CF = L.Coordinatore\n"
                    "GROUP BY P.Cognome,P.Nome\n"
                    "ORDER BY NumeroProgetti DESC\n";
    QueryArray[3] = "SELECT S.Nome AS Sede, SUM(P.Stipendio) AS TotaleStipendi\n"
                    "FROM (SELECT CF, Sede, Stipendio FROM Professionista UNION ALL SELECT CF, Sede, Stipendio FROM Direttore UNION ALL SELECT CF, Sede, Stipendio FROM Assistente) P JOIN Sede S ON P.Sede = S.Nome\n"
                    "GROUP BY S.Nome\n"
                    "ORDER BY S.Nome\n";
    QueryArray[4] = "SELECT A.Nome AS NomeAssistente, A.Cognome AS CognomeAssistente, SUM(CASE WHEN C.Partita_IVA IS NOT NULL THEN 1 ELSE 0 END) AS NumeroAssistenzeOrganizzazioni, SUM(CASE WHEN C.Partita_IVA IS NULL THEN 1 ELSE 0 END) AS NumeroAssistenzePrivati\n"
                    "FROM Assistente A JOIN Assistenza Asst ON A.CF = Asst.Assistente JOIN Cliente C ON Asst.Cliente = C.Email\n"
                    "GROUP BY A.Nome, A.Cognome\n";
    QueryArray[5] = "SELECT (SELECT SUM(ALL costo) as GuadagnoProgetti FROM lavoro l WHERE EXTRACT(YEAR FROM(l.fine))=$1::integer),\n"
                    "(SELECT SUM(prezzo_mensile * ((s.scadenza - s.inizio) / 30)) as GuadagnoAntivirus FROM sottoscrizione s JOIN antivirus a ON s.antivirus = a.versione WHERE EXTRACT(YEAR FROM(s.inizio)) = $1::integer)\n";
    QueryArray[6] = "SELECT d.nome, d.cognome, se.nome, SUM(l.costo) as guadagno\n"
                    "FROM lavoro l,svolgimento sv, sede se, direttore d, professionista p\n"
                    "WHERE l.id=sv.lavoro AND sv.professionista=p.cf AND p.sede=se.nome AND d.sede=se.nome\n"
                    "GROUP BY d.nome, d.cognome, se.nome\n"
                    "ORDER BY guadagno DESC\n";
}

void StampaMenu()
{
    cout << "Seleziona la query da eseguire:" << endl
         << "0) Esci dal programma" << endl
         << "1) Elenco delle email dei clienti che hanno speso piú di n euro in antivirus e che non hanno lasciato recensioni" << endl
         << "2) Elenco in ordine decresente degli antivirus con il maggior numero di sottoscrizioni e la media dei voti ricevuti" << endl
         << "3) Elenco in ordine decrescente dei nomi e cognomi dei professionisti che hanno svolto il ruolo di coordinatore, ordinati in base al numero di progetti" << endl
         << "4) Lista di denaro speso ogni anno da ogni sede per retribuire tutti i rispettivi dipendenti" << endl
         << "5) Elenco degli assistenti con il rispettivo numero di assistenze gestite, separate in base al tipo di cliente (organizzazione o privato)" << endl
         << "6) Soldi guadagnati nell'anno n dai contratti di lavoro e dalla vendita di antivirus" << endl
         << "7) Elenco in ordine decrescente dei nomi e cognomi dei direttori con le rispettive sedi che hanno guadagnato di piú dalle richieste di lavoro" << endl;
}

void printLine(int campi, const int *maxLen)
{
    for (int i = 0; i < campi; i++)
    {
        cout << '*';
        for (int j = 0; j < maxLen[i] + 2; j++)
            cout << '-';
    }
    cout << '*' << endl;
}

void StampaRisultati(PGresult *res)
{
    const int tuple = PQntuples(res), campi = PQnfields(res);
    string data[tuple + 1][campi];
    for (int i = 0; i < campi; ++i)
    {
        string s = PQfname(res, i);
        data[0][i] = s;
    }
    for (int i = 0; i < tuple; ++i)
        for (int j = 0; j < campi; ++j)
            data[i + 1][j] = PQgetvalue(res, i, j);

    int maxChar[campi];
    for (int i = 0; i < campi; ++i)
    {
        maxChar[i] = 0;
        for (int j = 0; j < tuple + 1; ++j)
        {
            int size = data[j][i].size();
            maxChar[i] = size > maxChar[i] ? size : maxChar[i];
        }
    }
    printLine(campi, maxChar);
    for (int j = 0; j < campi; ++j)
    {
        cout << "| ";
        cout << data[0][j];
        for (int k = 0; k < maxChar[j] - data[0][j].size() + 1; ++k)
            cout << ' ';
        if (j == (campi - 1))
            cout << "|";
    }
    cout << endl;
    printLine(campi, maxChar);
    for (int i = 1; i < (tuple + 1); ++i)
    {
        for (int j = 0; j < campi; ++j)
        {
            cout << "| ";
            cout << data[i][j];
            for (int k = 0; k < maxChar[j] - data[i][j].size() + 1; ++k)
                cout << ' ';
            if (j == (campi - 1))
                cout << "|";
        }
        cout << endl;
    }
    printLine(campi, maxChar);
}
