# Portainer

Portainer is a user-friendly, open-source container management solution that simplifies the deployment and management of Docker containers and services. With Portainer, you can easily manage your Docker environments using a graphical interface, making it a great tool for managing containerized applications. Portainer offers features like container creation, deployment, monitoring, and management, as well as support for Docker Compose, Kubernetes, and more.

To properly use this script, it is recommended that you have Docker and Docker Compose installed on your system. If you don't already have Docker and Docker Compose installed, you can follow the official installation guides for [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

## Setup

Before diving into the configuration details, it's important to have a basic understanding of the setup process. This section will walk you through the necessary steps to prepare your environment, and configure the required files.

### .env.example

The `.env.example` file is a template for the environment variables that are used to configure various services and settings for the Portainer project. To use this file, you should rename it to `.env` and replace the placeholder value with your actual value. This value is the path where the Portainer volume is stored.

### docker-compose.sh

The `docker-compose.sh` script is designed to deploy, stop, and remove Docker containers, networks, and volumes defined in the specified docker-compose.yml file. It handles the deployment and management of a Docker environment, setting up the necessary directory, copying configuration files, and running the appropriate Docker commands based on the provided arguments ('up' or 'down').

## Usage

To run the script, use the following command format:

```bash
sudo ./docker-compose.sh <command> <clean_stored_data>
```

Where `<command>` is either `up` or `down`, and `<clean_stored_data>` is a boolean value (`true` or `false`) that indicates whether to clean stored data in the Docker volume directory.

### Examples:

To deploy the Docker environment without cleaning stored data:
```bash
sudo ./docker-compose.sh up false
```

To deploy the Docker environment and clean stored data:
```bash
sudo ./docker-compose.sh up true
```

To stop and remove the Docker environment:
```bash
sudo ./docker-compose.sh down
```

> **Warning**
> Remember to replace the placeholder values in the ".env" file with your actual values before running the script.
