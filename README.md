# Docker (Compose) on Raspberry Pi Documentation

This documentation provides an insight into the setup and use of Docker (Compose) on a Raspberry Pi for the implementation of a Samba file server, a Tomcat web server, and a Jupyter Notebook. The project was developed as part of the course "Network and Operating Systems" at TEKO to convey practical experience in handling container applications on a Raspberry Pi.
## Services Utilization

### Samba Server

#### Establishing a Connection via SMB to the Host:
- **Ports**: Use `1390` and `4450` for the connection.
- **Example**: For Windows, use `\\<Raspberry-Pi-Address>:4450`; for Linux/macOS, use `smb://<Raspberry-Pi-Address>:4450`.

#### Shares:
- **Home Directory**: Each user has their own "Home" directory.
- **File Storage**: The `dateiablage` share is accessible only with a registered user and the corresponding password. Files are stored in the "samba_volume" volume for persistence.

### Tomcat Web Server

#### Accessing Tomcat:
- **Port**: The server is accessible through port `8080`.
- **Example**: Access the server via `http://<Raspberry-Pi-Address>:8080`.

#### Home Page:
- The `index.html` file located in `./tomcat/` acts as the starting page of the Tomcat server.

### Jupyter Notebook Server

#### Access to Jupyter Notebook:
- **Port**: Use port `8888` for connecting.
- **Example**: Connect through `http://<Raspberry-Pi-Address>:8888`.

#### Persistence of Notebooks:
- Jupyter Notebooks are saved in the `jupyter_volume`, ensuring data persistence.
