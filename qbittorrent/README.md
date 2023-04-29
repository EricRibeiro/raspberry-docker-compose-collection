# qBittorrent

qBittorrent is an open-source, cross-platform BitTorrent client that aims to provide an easy-to-use, feature-rich, and powerful alternative to other BitTorrent clients. Its advantages include a well-integrated, customizable search engine, support for all BitTorrent extensions, and a polished, user-friendly interface. It is recommended to use a VPN client when downloading content via qBittorrent to protect your privacy.

This repository provides a Docker Compose file with qBittorrent and WireGuard for the VPN setup. It has been tested using Mullvad VPN, with more details provided in the sections below. qBittorrent's default configuration comes from [TRaSH's setup guide](https://trash-guides.info/Downloaders/qBittorrent/Basic-Setup/).

## WireGuard

WireGuard is a modern, high-performance VPN protocol designed with simplicity, ease-of-use, and strong security in mind. Its advantages include being lightweight, fast, and easy to configure compared to other VPN protocols.

To use this Compose file, you need to obtain a `.conf` file from your VPN provider. For Mullvad, you can get the configuration file [here](https://mullvad.net/en/account/#/wireguard-config/). Rename the file to `wg0.conf` and place it in the `wireguard` directory, where you will also find a `wg0.conf.example` file for reference. Ensure that the server connection protocol is IPv4. This Compose file uses the [linuxserver/wireguard](https://docs.linuxserver.io/images/docker-wireguard) image.

### modprobe and ip6tables-restore error

When starting the WireGuard container, you may come across the following error:

```
modprobe: can't change directory to '/lib/modules': No such file or directory
ip6tables-restore v1.8.8 (legacy): ip6tables-restore: unable to initialize table 'raw'
```

This error can be found by running `docker logs wireguard`. It indicates that the required kernel module `ip6table_filter` is not loaded on the host system. Loading this module is essential for the proper functioning of WireGuard and the associated firewall rules.

To resolve this issue, load the `ip6table_filter` kernel module on the host system by executing the following command:

```bash
sudo modprobe ip6table_filter
```

The `modprobe` command adds or removes kernel modules from the Linux kernel. In this case, it loads the `ip6table_filter` module, which is necessary for WireGuard and ip6tables-restore to function correctly.

After running the command, the kernel module will be loaded, and the error should be resolved. However, this fix might need to be applied again if you reboot your system, as the kernel module may not be loaded automatically at startup. To make the change permanent, add the following line to the `/etc/modules` file:

```
ip6table_filter
```

This addition ensures that the `ip6table_filter` module is loaded automatically every time your system starts up, preventing the error from occurring in the future.

## Mullvad VPN

Mullvad VPN is a privacy-focused VPN service that offers strong encryption, a strict no-logs policy, and an easy-to-use interface. Its advantages include support for port forwarding. For more information, visit [this page](https://mullvad.net/en/help/port-forwarding-and-mullvad/). This Compose file has been tested with Mullvad VPN, but with minor changes, it should work with other providers.

### Testing Connection

After setting up the Docker environment, you can test if qBittorrent is connected to the internet via Mullvad VPN by running the following command:

```bash
docker exec -it qbittorrent curl https://am.i.mullvad.net/json
```

This command will return a JSON object containing information about the connection. If you are connected through Mullvad, the `mullvad_exit_ip` field in the response will be set to `true`. This test is based on the instructions provided by [Mullvad's Connection Check](https://mullvad.net/en/check).

To test if the port forwarding is working correctly, you can run the following command:

```bash
docker exec -it qbittorrent curl https://ipv4.am.i.mullvad.net/port/${QBITTORRENT_INCOMING_PORT}
```

Replace `${QBITTORRENT_INCOMING_PORT}` with the actual incoming port you have configured for qBittorrent. This command will return a JSON object containing the status of the tested port. If the port is open and correctly forwarded, the `status` field in the response will be set to `true`. This test is based on the instructions provided by [Mullvad's Port Forwarding Guide](https://mullvad.net/en/help/port-forwarding-and-mullvad/).

## Setup

This section provides a brief introduction to the setup process.

### .env.example

The `.env.example` file is a template with values that should be filled in and renamed to ".env".

#### DOCKER_DATA_VOLUME

This variable determines where the downloads will be stored. Before deciding on its value, read TRaSH's [Docker setup guide](https://trash-guides.info/Hardlinks/How-to-setup-for/Docker/) and Servarr's [Docker guide](https://wiki.servarr.com/docker-guide).

##### External SSD

I am testing this setup with an external SSD connected to a Raspberry Pi 4 and mounted in the OS. The following line in `/etc/fstab` mounts the SSD: `UUID=device_uuid /mount_directory auto nosuid,nodev,nofail,uid=1000,gid=1000 0 0`. This line requires the device UUID and user/group IDs, which are explained in more detail below.

To obtain the UUID of a device connected via USB, use the following command in the terminal:

```bash
sudo blkid
```

This command will list all connected devices, along with their UUIDs, file system types, and other details. Locate the appropriate device in the list and take note of its UUID.

To find the user and group IDs for the current user, run the following command:

```bash
id
```

This command will display the user and group IDs (uid and gid) for the current user. In the `/etc/fstab` line provided earlier, replace `device_uuid` with the actual UUID obtained from the `blkid` command, and replace `uid=1000,gid=1000` with the user and group IDs obtained from the `id` command.

After you've made changes to the `/etc/fstab` file, it's essential to test those changes before rebooting your system. This will help ensure that the device mounts correctly and prevent potential boot issues.

To test the changes to the `/etc/fstab` file, follow these steps:

1. If the device is already mounted, unmount it by running:

```bash
sudo umount /mount_directory
```

Replace `/mount_directory` with the actual mount directory specified in the `/etc/fstab` file.

2. Now, mount all filesystems specified in `/etc/fstab` by running:

```bash
sudo mount -a
```

This command will attempt to mount all filesystems listed in `/etc/fstab`, including the one you just modified.

3. Check if the device has been mounted correctly by running:

```bash
df -h
```

This command will display a list of mounted filesystems along with their sizes and mount points. Locate the device in the list and verify that it is mounted at the correct mount directory.

If the device is mounted correctly, your changes to the `/etc/fstab` file are valid, and the device will automatically mount at the specified directory on system startup. If you encounter any issues or errors during the mounting process, double-check the `/etc/fstab` line for any mistakes or typos, correct them, and repeat the steps above to test the changes again.

#### QBITTORRENT_INCOMING_PORT

The "QBITTORRENT_INCOMING_PORT" variable should be the port provided by Mullvad in their [port forwarding guide](https://mullvad.net/en/help/port-forwarding-and-mullvad/).

Here is the modified section "WEBUI_AUTH_SUBNET_WHITELIST" in the README file with the new information:

#### WEBUI_AUTH_SUBNET_WHITELIST

"WEBUI_AUTH_SUBNET_WHITELIST" should be the subnet of the Docker container running qBittorrent. To get the subnet of the Docker container, simply run the command below. This command will output the subnet, which you can set as the value of "WEBUI_AUTH_SUBNET_WHITELIST".

```bash
docker network inspect proxy &> /dev/null | grep -oP '"Subnet":\s*"\K[^"]+'
```

Before retrieving the subnet, make sure you have run the Traefik compose file (`../traefik/docker-compose.sh up`) first, as this file is responsible for the creation of the "proxy" network. If you don't want to run the Traefik compose file, you can create the "proxy" network manually.

## Legal Disclaimer

The purpose of this guide and the provided setup is for educational and informational purposes only. I do not endorse or support any form of piracy or unauthorized distribution of copyrighted content. Using the information provided in this guide to download or distribute copyrighted material without proper authorization is strictly prohibited and against the law.

The primary goal of this setup is to help users learn how to configure and use qBittorrent, Wireguard, and Docker Compose for legitimate use cases, such as downloading open-source software, legally shared content, and personal files. Please ensure that you use this setup responsibly and in compliance with the law.

By using this guide and the provided setup, you acknowledge that you are solely responsible for your actions and any consequences arising from your usage of the information provided.
