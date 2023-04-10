# Pi-hole

Pi-hole is a powerful network-wide ad blocker and DNS sinkhole that protects your devices from unwanted content and ads. By improving the browsing experience and enhancing the overall network performance, Pi-hole reduces the load from unwanted content.

Pi-hole uses `dnsmasq`, which allows for wildcard DNS, enabling you to easily access your services using a DNS instead of an IP address and port. For example, you can access your service at `service.example.com` instead of `192.168.1.100:8080`. For more details on wildcard DNS, check out this page: https://hetzbiz.cloud/2022/03/04/wildcard-dns-in-pihole/.

This setup automatically takes care of the DNS wildcard via the `dnsmasq.d/02-my-wildcard-dns.conf` file.

## DHCP

Unfortunately, I couldn't get the DHCP to work with this setup. I tried a setup similar to [this](https://codecaptured.com/blog/self-hosting-pi-hole-with-docker-and-traefik) without success. I am open to pull requests or suggestions on how to get it up and running.

Not having DHCP working is not a problem if you don't plan on using Pi-hole's DHCP. In my case, my router allows me to change its DHCP configuration; therefore, is not a feature I require.

## Setup

### .env.example

The `.env.example` file is a template with values that should be filled in and renamed to ".env".

#### DOCKER_VOLUME

This variable represents the path to the Docker volume that stores the configuration files and dependencies for the project. Replace the placeholder value with the appropriate path on your system.

#### HOST_IP_ADDRESS

This variable represents the IP address of the host machine running the setup. It is necessary for proper configuration of the wildcard DNS and the services in general. Replace the placeholder value with the IP address of your host machine.
