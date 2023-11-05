# Dokumentation: Docker (Compose) auf Raspberry Pi

### Einleitung

Diese Dokumentation beschreibt die Einrichtung und Verwendung von Docker (Compose) auf einem Raspberry Pi für die Bereitstellung eines Samba-Dateiservers, eines Tomcat-Web-Servers sowie eines NTP Zeitservers. 

### Installation von Docker auf dem Raspberry Pi

Vor der Verwendung von Docker muss sichergestellt werden, dass das Betriebssystem des Raspberry Pis auf dem neuesten Stand ist:

```
sudo apt update
sudo apt upgrade -y
```

Anschliessend kann Docker installiert werden (siehe auch https://docs.docker.com/engine/install/ubuntu/):

```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

### Einrichtung von Docker Compose

Docker Compose erleichtert die Verwaltung von Multi-Container-Docker-Anwendungen. Die Installation erfolgt mit dem Befehl:

```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
```

### Docker Compose Konfiguration

Die docker-compose.yml-Datei definiert drei Dienste: samba, tomcat und ntp.

- Samba: Stellt einen Dateiserver zur Verfügung und ermöglicht den Dateiaustausch zwischen Containern und dem Host-System.
- Tomcat: Ein Webserver, der Java-Webanwendungen hostet.
- NTP: Synchronisiert die Systemzeit mit NTP-Servern.
Verwaltung mit Docker Compose

Um die definierten Dienste zu starten, verwende:

```
docker-compose up -d
```

Dieser Befehl startet alle Dienste im Hintergrund. Um sie zu stoppen und alle zugehörigen Ressourcen zu entfernen, verwende:

```
docker-compose down
```

### Dokumentation der docker-compose.yml

Die `docker-compose.yml` definiert Dienste, Netzwerke und Volumes.

- services: Definiert die drei Hauptdienste (samba, tomcat, ntp).
- samba:
Nutzt das dperson/samba-Image für die Bereitstellung des Samba-Dienstes.
Konfiguriert einen Benutzer und eine Freigabe.
Volumes sorgen für die Datenpersistenz.
Ports werden auf nicht standardmässige Ports gemappt, um Kollisionen zu vermeiden.
- tomcat:
Verwendet das neueste Tomcat-Image von Docker Hub.
Der Port 8080 ist für den Zugriff auf Tomcat vom Host aus freigegeben.
Ein Volume speichert die Webanwendungen persistent.
Eine lokale index.html-Datei wird in den webapps/ROOT-Ordner gemappt, um eine Homepage bereitzustellen.
- ntp:
Verwendet das cturra/ntp-Image.
Stellt sicher, dass die Zeit im Netzwerk synchronisiert bleibt.
Benötigt keine externen Ports und kommuniziert nur intern.
- - networks: Konfiguriert ein internes Netzwerk für die Kommunikation zwischen den Diensten und ein Standardnetzwerk für den Zugriff von aussen.
volumes: Definiert die Volumes für Samba und Tomcat zur Datenspeicherung.
Zusammenfassung

Mit dieser Konfiguration kann eine praktische Umgebung eingerichtet werden, um Dienste wie Samba und Tomcat zu verstehen und zu verwalten.