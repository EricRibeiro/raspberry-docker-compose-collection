# Raspberry Docker Compose Collection
This repository contains a collection of Docker Compose configurations for various services designed to run on a Raspberry Pi. Running these services via Docker allows for better isolation, easier management, and simpler upgrades compared to installing each of them natively on the Raspberry Pi. Each service has its own README.md file with instructions on how to run and configure them.

## Environment Files
There are environment files in the root of the repository and in each service folder containing the necessary variables required to run the services. These environment files have an "example" suffix that must be removed, and the files themselves must be populated with appropriate values.

These environment files are used by the bash scripts inside each service folder to prepare the host environment to run the Docker container. This preparation is usually in the form of preparing a folder and its contents to be mounted in the container.

## Shell Scripts
Every service has a "docker-compose.sh" script. These scripts are essentially wrappers for Docker's native compose command. Running the native command directly won't work because it won't inject the variables from "global.env" and ".env", and it won't ensure that the host has the necessary content in the mounted volumes to spin up the container.

It's important to use the provided scripts to spin up and down every service. The README.md files inside each service folder have more information and usage examples of these scripts.

## Feedback
All feedback is welcome, and users are encouraged to open pull requests and issues to help improve this repository.

## Future Work
More services will be added in the future as I learn how to set them up with Traefik. This will expand the collection and provide more options for Raspberry Pi users looking to self-host a variety of services.
