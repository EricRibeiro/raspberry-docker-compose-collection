# Pi-hole

Pi-hole is a powerful network-wide ad blocker and DNS sinkhole that protects your devices from unwanted content and ads. By improving the browsing experience and enhancing the overall network performance, Pi-hole reduces the load from unwanted content.

Pi-hole uses `dnsmasq`, which allows for wildcard DNS, enabling you to easily access your services using a DNS instead of an IP address and port. For example, you can access your service at `service.example.com` instead of `192.168.1.100:8080`. For more details on wildcard DNS, check out this page: https://hetzbiz.cloud/2022/03/04/wildcard-dns-in-pihole/.

This setup automatically takes care of the DNS wildcard via the `dnsmasq.d/02-my-wildcard-dns.conf` file.

## DHCP

Unfortunately, I couldn't get the DHCP to work with this setup. I tried a setup similar to [this](https://codecaptured.com/blog/self-hosting-pi-hole-with-docker-and-traefik) without success. I am open to pull requests or suggestions on how to get it up and running.

Not having DHCP working is not a problem if you don't plan on using Pi-hole's DHCP. In my case, my router allows me to change its DHCP configuration; therefore, is not a feature I require.

## Setup

### .env.example

In this setup, you'll find an ".env.example" file that contains environment variables used to configure various services and settings for the project. Rename this file to ".env" and replace the placeholder values with your actual values. The variables in the ".env.example" file are:

- `DOCKER_VOLUME`: The path to the Pi-hole Docker volume. It stores the configuration files and dependencies for the project.
- `HOST_IP_ADDRESS`: The IP address of the host machine running Pi-hole. This is necessary for proper configuration of the wildcard DNS.

### docker-compose.sh

The "docker-compose.sh" script is designed to deploy, stop, and remove Docker containers, networks, and volumes defined in the specified `docker-compose.yml` file. It handles the deployment and management of the Docker environment, setting up the necessary directory, copying configuration files, and running the appropriate Docker commands based on the provided arguments ('up' or 'down').

## Usage

To run the script, use the following command format:

```bash
sudo ./docker-compose.sh <command> <clean_stored_data>
```

Where `<command>` is either `up` or `down`, and `<clean_stored_data>` is a boolean value (`true` or `false`) that indicates whether to clean stored data in the Docker volume directory.

### Examples:

To deploy the Docker environment without cleaning stored data (useful to clean Pi-hole's data):
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
