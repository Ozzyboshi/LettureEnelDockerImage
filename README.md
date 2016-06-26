LettureEnel Applicazione web
================================

LettureEnel è una applicazione web per registrare e tenere traccia dei consumi rilevati da contatori ENEL in regime di scambio sul posto.

Letture Enel permette di registrare su di un database mysql ciò che viene riportato dai contatori Enel, in particolare:
* Consumi da rete ENEL
* Immissioni del proprio impianto fotovoltaico su rete ENEL
* Produzione del proprio impianto fotovoltaico
Tutti gli inserimenti sono divisi per fascia oraria (F1,F2 e F3).

Da questi dati di input viene poi calcolata una pagina con i delta dei consumi per ogni intervallo temporale, il calcolo dei consumi sfruttando la produzione del fotovoltaico e un suo rapporto con i consumi totali.

REQUISITI
------------

Un interprete php e un server MySQL e un web server.

INSTALLAZIONE
------------

### Installazione da sorgenti

* Clonare i sorgenti dal [Github repository](https://github.com/Ozzyboshi/LettureEnel.git) in una directory sotto la Web root (solitamente /var/www).
* Editare il file config/db.php e immettere i dati necessari alla connessione al server MySQL come da esempio:
```php
return [
    'class' => 'yii\db\Connection',
    'dsn' => 'mysql:host=localhost;dbname=lettureenel',
    'username' => 'root',
    'password' => '1234',
    'charset' => 'utf8',
];
```
* Lanciare composer update per generare la cartella 'vendor'
* Creare le tabelle e i records necessari per il funzionamento della applicazione web, per fare cio lanciare ./yii migrate dalla root del progetto.
* Se non si dispone di un proprio server web lanciare ./yii serve
* Richiamare la applicazione web dal proprio browser inserendo l'indirizzo ip del server

### Installazione con Docker
Per installare la applicazione web usando docker occorre prima creare un container con un server mysql e creare il database che conterrà i dati, ad esempio:
```
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
docker exec -it some-mysql mysql -e "create database lettureenel" -pmy-secret-pw -u root --host localhost
```
quindi procedere con il container che conterrà l'installazione vera e propria della applicazione web:
```
docker run --name lettureenel -p 80:80 -e "DB_USER=root" -e "DB_PASS=my-secret-pw" -e "DB_STRING=mysql:host=db;dbname=lettureenel" -e "DATALOGGER_URL=http://home1.solarlog-web.it/" --link some-mysql:db -d ozzyboshi/lettureeneldockerimage
docker exec -it lettureenel ./yii migrate
```


CONFIGURAZIONE
-------------

### Utenti

Ad installazione avvenuta è possibile autenticarsi come amministratore cliccando sul tasto Login in alto a destra, le credenziali di accesso sono admin/admin.

Ovviamente è conigliato cambiare la password di amministrazione dopo il primo accesso.
E' inoltre possibile creare nuovi utenti, una volta creato un nuovo utente occorre assegnargli i permessi di admin attraverso la pagina /index.php/admin/assignment, questa operazione inizialmente è concessa solo all'utente admin.

In questo momento non esiste una procedura di cancellazione utenti.

### Demo

E' presente una demo online di questa applicazione all'indirizzo [http://lettureenel.ozzyboshi.com/](http://lettureenel.ozzyboshi.com/)

