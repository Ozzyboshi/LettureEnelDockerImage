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
docker exec -it web_lettureenelmysql_1 mysql -e "ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'my-secret-pw';" -pmy-secret-pw -u root --host localhost
```
L'ultima istruzione è necessaria solo per Mysql8, nel caso vi renda questo errore in fase di migrate:
```
Exception 'yii\db\Exception' with message 'SQLSTATE[HY000] [2059] Authentication plugin 'caching_sha2_password' cannot be loaded: /usr/lib/mysql/plugin/caching_sha2_password.so: cannot open shared object file: No such file or directory'
```


quindi procedere con il container che conterrà l'installazione vera e propria della applicazione web:
-# Versione non sicura (HTTP su porta 80)
```
docker run --name lettureenel -p 80:80 -e "DB_USER=root" -e "DB_PASS=my-secret-pw" -e "DB_STRING=mysql:host=db;dbname=lettureenel" -e "DATALOGGER_URL=http://home1.solarlog-web.it/" --link some-mysql:db -d ozzyboshi/lettureeneldockerimage
```

-# Versione solo sicura (HTTPS su porta 443)
```
mkdir /web
cd /web && python -m SimpleHTTPServer 80 &
docker run -v /web:/web -v /certs:/etc/letsencrypt/archive fauria/letsencrypt yourdomain --email youremail
docker run --name lettureenel -v /certs/yourdomain:/etc/certdir -p 443:443 -e "DB_USER=root" -e "DB_PASS=my-secret-pw" -e "DB_STRING=mysql:host=db;dbname=lettureenel" -e "DATALOGGER_URL=http://home1.solarlog-web.it/" --link some-mysql:db -d ozzyboshi/lettureeneldockerimage /var/www/LettureEnel/start.sh secureonly
```

-# Entrambe le versioni
```
docker run --name lettureenel -p 80:80 -p 443:443 -e "DB_USER=root" -e "DB_PASS=my-secret-pw" -e "DB_STRING=mysql:host=db;dbname=lettureenel" -e "DATALOGGER_URL=http://home1.solarlog-web.it/" --link some-mysql:db -d ozzyboshi/lettureeneldockerimage start 
```

Infine terminare l'installazione con
```
docker exec -it lettureenel ./yii migrate
docker exec -it lettureenel composer update
```


CONFIGURAZIONE
-------------

### Utenti

Ad installazione avvenuta è possibile autenticarsi come amministratore cliccando sul tasto Login in alto a destra, le credenziali di accesso sono admin/admin.

Ovviamente è conigliato cambiare la password di amministrazione dopo il primo accesso.
E' inoltre possibile creare nuovi utenti, una volta creato un nuovo utente occorre assegnargli i permessi di admin attraverso la pagina /index.php/admin/assignment, questa operazione inizialmente è concessa solo all'utente admin.

In questo momento non esiste una procedura di cancellazione utenti.

### Demo

E' presente una demo online di questa applicazione all'indirizzo [https://lettureeneldemo.ozzyboshi.com/](https://lettureeneldemo.ozzyboshi.com/)

