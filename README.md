# Raspberry Docker Compose Collection
This repository contains a collection of Docker Compose configurations for various services designed to run on a Raspberry Pi. Running these services via Docker allows for better isolation, easier management, and simpler upgrades compared to installing each of them natively on the Raspberry Pi. Each service has its own README.md file with instructions on how to run and configure them.

In this collection, Traefik serves as the backbone for all the included services. The main goal is to have all services running seamlessly behind Traefik, providing a unified and secure access point. To help users quickly verify if a service behind Traefik is reachable, the `whoami` service is included, following the example provided in the [Traefik Quick Start guide](https://doc.traefik.io/traefik/getting-started/quick-start/).

## Environment Files
There are environment files in the root of the repository and in each service folder containing the necessary variables required to run the services. These environment files have an "example" suffix that must be removed (i.e., global.env and .env), and the files themselves must be populated with appropriate values.

These environment files are used by the bash scripts inside each service folder to prepare the host environment to run the Docker container. This preparation is usually in the form of preparing a folder and its contents to be mounted in the container.

## Shell Scripts
Every service has a `docker-compose.sh` script. These scripts are essentially wrappers for Docker's native compose command. Running the native command directly won't work because it won't inject the variables from `global.env` and `.env`, and it won't ensure that the host has the necessary content in the mounted volumes to spin up the container. It's important to use the provided scripts to spin up and down every service. For usage details, refer to the section below.

### Usage

The `docker-compose.sh` script is responsible for deploying, stopping, and removing Docker containers, networks, and volumes defined in the Compose file. To use the script, run the following command from the service folder you want to deploy:

```bash
chmod +x docker-compose.sh # only required for the first run
sudo ./docker-compose.sh <command> <clean_stored_data> <overwrite_stored_data> <sub_directories> <owner> <group>
```

Where:

- `<command>` is either `up` or `down`.
- `<clean_stored_data>` is a boolean value (`true` or `false`) indicating whether to clean stored data in the Docker volume directory.
- `<overwrite_stored_data>` is a boolean value (`true` or `false`) indicating whether to overwrite stored data in the Docker volume directory.
- `<sub_directories>` is a string containing subdirectories to be created in the Docker volume directory (optional).
- `<owner>` is the owner of the created files and directories (optional; default: SUDO_USER).
- `<group>` is the group of the created files and directories (optional; default: SUDO_USER).

#### Examples:

1. To deploy the Docker environment without cleaning or overwriting stored data, and create "qBittorrent" and "wireguard" subdirectories with the owner and group set to "ericribeiro":

```bash
sudo ./docker-compose.sh up false false "qBittorrent,wireguard" "ericribeiro" "ericribeiro"
```

2. To deploy the Docker environment, clean stored data, overwrite existing data, and create "qBittorrent" and "wireguard" subdirectories with the owner and group set to "ericribeiro":

```bash
sudo ./docker-compose.sh up true true "qBittorrent,wireguard" "ericribeiro" "ericribeiro"
```

3. To stop and remove the Docker environment, and create "qBittorrent" and "wireguard" subdirectories with the owner and group set to "ericribeiro":

```bash
sudo ./docker-compose.sh down false false "qBittorrent,wireguard" "ericribeiro" "ericribeiro"
```

> **Warning**
> Remember to replace the placeholder values in the ".env" file with your actual values before running the script.

## Feedback
All feedback is welcome, and users are encouraged to open pull requests and issues to help improve this repository.

## Future Work
More services will be added in the future as I learn how to set them up with Traefik. This will expand the collection and provide more options for Raspberry Pi users looking to self-host a variety of services.
