# Dokumentation: Docker (Compose) auf Raspberry Pi

### Einleitung

Diese Dokumentation beschreibt die Einrichtung und Verwendung von Docker (Compose) auf einem Raspberry Pi für die Bereitstellung eines Samba-Dateiservers, eines Tomcat-Web-Servers sowie eines Jupyter Notebooks. 

## Installation von Docker auf dem Raspberry Pi

### Installation und Updates

Vor der Verwendung von Docker muss sichergestellt werden, dass das Betriebssystem des Raspberry Pis auf dem neuesten Stand ist. Wir verwenden die Linux-Distribution Debian (V12.0 - "Bookworm"):

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

Die docker-compose.yml-Datei definiert drei Dienste: samba, tomcat und jupyter.

- Samba: Stellt einen Dateiserver zur Verfügung und ermöglicht den Dateiaustausch zwischen Containern und dem Host-System.
- Tomcat: Ein Webserver, der Java-Webanwendungen hostet.
- Jupyter Notebook: Eine Client-Server-Anwendung für das Erstellen und Teilen interaktiver Arbeitsblätter

Um die definierten Dienste zu starten, verwende:

```
docker-compose up -d
```

Dieser Befehl startet alle Dienste im Hintergrund. Um sie zu stoppen und alle zugehörigen Ressourcen zu entfernen, verwende:

```
docker-compose down
```

## Docker Compose Konfiguration

Die `docker-compose.yml`-Datei definiert drei Hauptdienste: `samba`, `tomcat` und `jupyter`.

### Dienste

- **Samba**:
    - Verwendet das `dperson/samba`-Image zur Bereitstellung eines Samba-Dienstes.
    - Konfiguriert einen Benutzer (`patrik.burkhalter`) und eine Freigabe (`dateiablage`).
    - Volumes ermöglichen die Datenpersistenz.
    - Ports `1390` und `4450` sind für den Zugriff auf Samba vom Host aus freigegeben, um Standardportkollisionen zu vermeiden.

- **Tomcat**:
    - Nutzt das neueste offizielle Tomcat-Image von Docker Hub.
    - Port `8080` ist für den Webzugriff vom Host aus freigegeben.
    - Ein Volume speichert die Webanwendungen von Tomcat persistent.
    - Eine lokale `index.html`-Datei wird in den `webapps/ROOT`-Ordner des Tomcat-Servers gemappt, um eine Homepage bereitzustellen.

- **Jupyter**:
    - Setzt das `quay.io/jupyter/scipy-notebook`-Image für ein Scipy-Notebook (Scientific Python) ein.
    - Port `8888` ist für den Zugriff auf die Jupyter Notebook-Weboberfläche vom Host aus freigegeben.
    - Ein Volume ermöglicht die persistente Speicherung der Jupyter Notebooks.

### Netzwerke

- **internal_network**:
    - Ein internes Netzwerk, das die Kommunikation zwischen den Diensten ohne externen Zugang ermöglicht.

- **external_network**:
    - Ein Netzwerk für den Zugriff von außen sowie vom Host-System.

### Volumes

- **samba_volume**:
    - Stellt die Persistenz für den Samba-Dateiserver sicher.

- **tomcat_volume**:
    - Hält die Webanwendungen von Tomcat persistent vor.

- **jupyter_volume**:
    - Sichert die Scipy Notebooks des Jupyter-Notebook-Servers dauerhaft.

### Zusammenfassung

Diese Konfiguration ermöglicht es, auf einem Raspberry Pi verschiedene Netzwerkdienste einzurichten und zu verwalten. Die klar definierten Dienste, Netzwerke und Volumes unterstützen die einfache und effiziente Entwicklung sowie das Hosting von Anwendungen und Diensten.


## Nutzung der Dienste

### Samba-Server

- **Verbindungsaufbau über SMB zum Host:**
    - Verwenden Sie die angepassten Ports `1390` und `4450`.
    - Beispiel: \\<Raspberry-Pi-Adresse>:4450 oder smb://<Raspberry-Pi-Adresse>:4450
- **Zugriff auf die Freigabe:**
    - Die Freigabe `dateiablage` ist nur mit dem Benutzernamen `patrik.burkhalter` und dem dazugehörigen Passwort zugänglich.

### Tomcat-Webserver

- **Zugriff auf Tomcat:**
    - Öffnen Sie Ihren Webbrowser und navigieren Sie zu `http://<Raspberry-Pi-Adresse>:8080`.
- **Startseite:**
    - Die `index.html`-Datei im Verzeichnis `./tomcat/` dient als Startseite des Tomcat-Servers.

### Jupyter Notebook-Server

- **Zugang zu Jupyter Notebook:**
    - Öffnen Sie `http://<Raspberry-Pi-Adresse>:8888` in Ihrem Webbrowser.
- **Persistenz der Notebooks:**
    - Ihre Jupyter Notebooks werden im `jupyter_volume` gespeichert und sind dort persistent hinterlegt.
