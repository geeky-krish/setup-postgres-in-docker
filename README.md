# PostgreSQL and pgAdmin Setup with Docker

This `setup.sh` script automates the setup of PostgreSQL and pgAdmin containers in Docker. It creates a custom network, handles volumes for data persistence, and provides easy access to pgAdmin for managing your PostgreSQL instance.

### Features:

- Creates a custom Docker network.
- Sets up PostgreSQL container with persistent data volume.
- Sets up pgAdmin4 container for database management.
- Provides connection details to PostgreSQL and access link for pgAdmin4.

---

## Prerequisites

Before running the script, make sure you have the following installed:

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose** (optional): [Install Docker Compose](https://docs.docker.com/compose/install/)

You can verify that Docker is installed by running:

```bash
docker --version
```

## How to Use

### 1. Clone the Repository (if you haven't already)

Clone the repository that contains the `setup.sh` script:

```bash
git clone https://github.com/geeky-krish/setup-postgres-in-docker.git
cd setup-postgres-in-docker
```

### 2. Make the Script Executable

If the `setup.sh` script is not executable, run the following command to make it executable:

```bash
chmod +x setup.sh
```

### 3. Run the Script

Execute the `setup.sh` script to set up PostgreSQL, pgAdmin, and the necessary Docker network:

```bash
./setup.sh
```

### 4. Access pgAdmin

After the script completes, you can access **pgAdmin** at [http://localhost:5050](http://localhost:5050) using the credentials you provided in the script:

- **Email**: `geeky@krishna.com` (or as set in the script)
- **Password**: `geeky@123` (or as set in the script)

You can now connect pgAdmin to your PostgreSQL container using the following connection details:

- **Host**: `host.docker.internal`
- **Port**: `5432`
- **Username**: `admin` (as set in the script)
- **Password**: `geeky@123` (as set in the script)

---

## Script Breakdown

- **Network Creation**: The script checks if the Docker network (`pg_network`) exists. If not, it creates one.
- **PostgreSQL Setup**: The script launches the PostgreSQL container (`postgres-db`) with environment variables for the database user and password. It also attaches a persistent volume (`postgres-db-volume`) for data storage.
- **pgAdmin Setup**: The script runs pgAdmin4 (`pgadmin4`) with the provided email and password for accessing the web interface.
- **Checking Status**: The script checks if the PostgreSQL and pgAdmin containers are running successfully and provides the status.
- **Access Information**: Finally, the script gives you the link to access pgAdmin and the connection details for PostgreSQL.

---

## Troubleshooting

- **PostgreSQL Not Starting**: Ensure Docker is running and there are no conflicting containers using port `5432`.
- **pgAdmin Not Accessible**: Verify the pgAdmin container is running and port `5050` is not blocked by a firewall.
- **Connection Issues**: If you can't connect to the PostgreSQL database, ensure the correct hostname (`host.docker.internal`) and port (`5432`) are used in pgAdmin.

---

## Customization

You can easily customize the following parameters in the script:

- **Network Name**: `$NETWORK_NAME` (default: `pg_network`)
- **PostgreSQL Container Name**: `$PG_CONTAINER_NAME` (default: `postgres-db`)
- **pgAdmin Container Name**: `$PGADMIN_CONTAINER_NAME` (default: `pgadmin4`)
- **PostgreSQL Volume**: `$VOLUME_NAME` (default: `postgres-db-volume`)
- **PostgreSQL Username**: `$POSTGRES_USERNAME` (default: `admin`)
- **PostgreSQL Password**: `$POSTGRES_PASS` (default: `geeky@123`)
- **pgAdmin Email**: `$PGADMIN_EMAIL` (default: `geeky@krishna.com`)
- **pgAdmin Password**: `$PGADMIN_PASS` (default: `geeky@123`)

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

By using the `setup.sh` script, you’ll have a PostgreSQL instance and pgAdmin running in Docker with minimal effort. Enjoy managing your databases!
