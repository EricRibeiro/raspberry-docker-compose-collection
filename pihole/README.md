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

#### PIHOLE_DNS

The "PIHOLE_DNS" variable represents the DNS server used by Pi-hole. By default, it is set to "127.0.0.1", the loopback address, meaning the host device will use Pi-hole for DNS resolution. This configuration works well in most cases, but can cause issues if Pi-hole goes offline or experiences problems, as the host device may lose internet connectivity for troubleshooting or uploading debug logs.

Since Pi-hole V5, the host device's name server remains unchanged during the installation, allowing you to choose an alternative DNS server for the host device if desired. For better resilience and troubleshooting, you may prefer to use a public DNS server, such as Cloudflare (1.1.1.1), OpenDNS, or Google DNS (8.8.8.8), as the "PIHOLE_DNS" value. This ensures that any issues with your local DNS server will not prevent your host device from accessing the internet.

In summary, you can keep the default loopback address (127.0.0.1) if you want the host device to use Pi-hole for DNS resolution, or you can choose a public DNS server for increased reliability and easier troubleshooting.
