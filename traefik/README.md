# Traefik

Traefik is a modern, dynamic reverse proxy and load balancer that simplifies the deployment and management of microservices. It is designed to handle routing and load balancing requests from multiple sources to different services, making it a great tool for managing containerized applications. By using Traefik, you can benefit from features like automatic SSL certificate generation, service discovery, and seamless integration with popular orchestration tools.

To properly use this script, it is recommended that you own a domain from a domain registrar. This is because the script is designed to generate SSL certificates for your domain using Let's Encrypt, which requires a valid domain. Without a valid domain, the SSL certificates will not be generated correctly, and your browser will display warnings about invalid certificates.

## Cloudflare

Cloudflare is a global content delivery network (CDN) and security company that provides DNS, DDoS protection, and other services to enhance website performance and security. This docker-compose file assumes that Cloudflare is the DNS provider for your domain.

To set up Cloudflare as your DNS provider and change your nameservers, follow the instructions provided in this guide: [Cloudflare Full Zone Setup](https://developers.cloudflare.com/dns/zone-setups/full-setup/setup/)

## Setup

Before diving into the configuration details, it's important to have a basic understanding of the setup process. This section will walk you through the necessary steps to prepare your environment, and configure the required files.

### .env.example

The `.env.example` file is a template for the environment variables that are used to configure various services and settings for the Traefik project. To use this file, you should rename it to `.env` and replace the placeholder values with your actual values. These values include your Cloudflare account email, API token for DNS access, Traefik basic authentication credentials, and the path where the Traefik volume is stored.

To create your Cloudflare API token, navigate to https://dash.cloudflare.com/profile/api-tokens and generate a new token. Ensure that the token has "Zone.DNS" edit permissions. It is recommended to restrict the token to only the domain used for Traefik as the zone resource. This will help isolate the token, making it more secure and less prone to potential misuse.

### docker-compose.sh

The `docker-compose.sh` script is designed to deploy, stop, and remove Docker containers, networks, and volumes defined in the specified docker-compose.yml file. It handles the deployment and management of a Docker environment, setting up the necessary directory, copying configuration files, and running the appropriate Docker commands based on the provided arguments ('up' or 'down').

## Usage

To run the script, use the following command format:

```bash
sudo ./docker-compose.sh <command> <clean_stored_data>
```

Where `<command>` is either `up` or `down`, and `<clean_stored_data>` is a boolean value (`true` or `false`) that indicates whether to clean stored data in the Docker volume directory.

### Examples:

To deploy the Docker environment without cleaning stored data (useful to avoid recreating certs and hitting Let's Encrypt API limit):
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
