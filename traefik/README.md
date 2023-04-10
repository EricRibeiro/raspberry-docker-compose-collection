# Traefik

Traefik is a modern, dynamic reverse proxy and load balancer that simplifies the deployment and management of microservices. It is designed to handle routing and load balancing requests from multiple sources to different services, making it a great tool for managing containerized applications. By using Traefik, you can benefit from features like automatic SSL certificate generation, service discovery, and seamless integration with popular orchestration tools.

To properly use this script, it is recommended that you own a domain from a domain registrar. This is because the script is designed to generate SSL certificates for your domain using Let's Encrypt, which requires a valid domain. Without a valid domain, the SSL certificates will not be generated correctly, and your browser will display warnings about invalid certificates.

## Cloudflare

Cloudflare is a global content delivery network (CDN) and security company that provides DNS, DDoS protection, and other services to enhance website performance and security. This docker-compose file assumes that Cloudflare is the DNS provider for your domain.

To set up Cloudflare as your DNS provider and change your nameservers, follow the instructions provided in this guide: [Cloudflare Full Zone Setup](https://developers.cloudflare.com/dns/zone-setups/full-setup/setup/)

## Setup

This section provides a brief introduction to the setup process.

### .env.example

The `.env.example` file is a template with values that should be filled in and renamed to ".env".

#### CA_SERVER_PRODUCTION

This variable represents the Let's Encrypt production API endpoint. It is set to `https://acme-v02.api.letsencrypt.org/directory` by default, and you should not change it.

#### CA_SERVER_STAGING

This variable represents the Let's Encrypt staging API endpoint. It is set to `https://acme-staging-v02.api.letsencrypt.org/directory` by default, and you should not change it.

#### CF_API_EMAIL

This variable represents the email address associated with your Cloudflare account. Replace the placeholder value `your_cloudflare_email` with the email address you use for your Cloudflare account.

#### CF_DNS_API_TOKEN

This variable represents the API token for your Cloudflare account with DNS access. Replace the placeholder value `your_cloudflare_token` with the API token you obtained from your Cloudflare account.

#### DOCKER_VOLUME

This variable represents the path where the Traefik volume is stored. The default value is `${DOCKER_VOLUME_ROOT}/traefik`, where `${DOCKER_VOLUME_ROOT}` should be set in the "global.env" file. Replace the placeholder value with the appropriate path on your system if needed.

#### TRAEFIK_PASSWORD

This variable represents the basic authentication password for the Traefik dashboard. Replace the placeholder value `your_traefik_basic_auth_password` with a secure password of your choice.

#### TRAEFIK_USER

This variable represents the basic authentication username for the Traefik dashboard. Replace the placeholder value `your_traefik_basic_auth_user` with a username of your choice.
