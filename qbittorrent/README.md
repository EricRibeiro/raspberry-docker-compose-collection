# qBittorrent

qBittorrent is an open-source, cross-platform BitTorrent client that aims to provide an easy-to-use, feature-rich, and powerful alternative to other BitTorrent clients. Its advantages include a well-integrated, customizable search engine, support for all BitTorrent extensions, and a polished, user-friendly interface. It is recommended to use a VPN client when downloading content via qBittorrent to protect your privacy.

This repository provides a Docker Compose file with qBittorrent and WireGuard for the VPN setup. It has been tested using Mullvad VPN, with more details provided in the sections below. qBittorrent's default configuration comes from [TRaSH's setup guide](https://trash-guides.info/Downloaders/qBittorrent/Basic-Setup/).

## WireGuard

WireGuard is a modern, high-performance VPN protocol designed with simplicity, ease-of-use, and strong security in mind. Its advantages include being lightweight, fast, and easy to configure compared to other VPN protocols.

To use this Compose file, you need to obtain a ".conf" file from your VPN provider. For Mullvad, you can get the configuration file [here](https://mullvad.net/en/account/#/wireguard-config/). Rename the file to "wg0.conf" and place it in the "wireguard" directory, where you will also find a "wg0.conf.example" file for reference. Ensure that the server connection protocol is IPv4. This Compose file uses the [linuxserver/wireguard](https://docs.linuxserver.io/images/docker-wireguard) image.

## Mullvad VPN

Mullvad VPN is a privacy-focused VPN service that offers strong encryption, a strict no-logs policy, and an easy-to-use interface. Its advantages include support for port forwarding. For more information, visit [this page](https://mullvad.net/en/help/port-forwarding-and-mullvad/). This Compose file has been tested with Mullvad VPN, but with minor changes, it should work with other providers.

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

#### WEBUI_AUTH_SUBNET_WHITELIST

"WEBUI_AUTH_SUBNET_WHITELIST" should be the subnet of the Docker container running qBittorrent. This can be found by running `docker exec -it qbittorrent hostname -i`. This command returns the container's IP address but not the subnet. To determine the subnet, follow these steps:

1. First, inspect the Docker network that the qBittorrent container is connected to. Replace `<network_name>` with the actual name of the Docker network:

```bash
docker network inspect <network_name>
```

In the output, find the "Containers" section, and locate the qBittorrent container by its name or container ID. Within the container's information, you will find the `"IPv4Address"` key, which contains the container's IP address and subnet mask. The subnet mask will be in the format `x.x.x.x/yy`. For example:

```
"IPv4Address": "192.168.1.5/24"
```

In this example, the subnet mask is `/24`.

2. To calculate the subnet from the IP address and subnet mask, follow these steps:

- Convert the IP address (e.g., `192.168.1.5`) and the subnet mask in CIDR notation (e.g., `/24`) to their binary representations.
- Perform a bitwise AND operation between the binary IP address and the binary subnet mask.
- Convert the result back to the decimal format, which represents the subnet.

In our example, the IP address `192.168.1.5` in binary is `11000000.10101000.00000001.00000101`, and the subnet mask `/24` in binary is `11111111.11111111.11111111.00000000`. Performing a bitwise AND operation, we get `11000000.10101000.00000001.00000000`, which, when converted back to decimal, results in the subnet `192.168.1.0/24` (you can also use an online calculator 🤭).

Now, set the "WEBUI_AUTH_SUBNET_WHITELIST" to the calculated subnet, which, in this example, is `192.168.1.0/24`.

### docker-compose.sh

The `docker-compose.sh` script is responsible for deploying, stopping, and removing Docker containers, networks, and volumes defined in the Compose file. This section explains how to use the script, detailing each parameter and providing examples with different parameter combinations.

To use the script, run the following command:

```bash
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

## Legal Disclaimer

The purpose of this guide and the provided setup is for educational and informational purposes only. I do not endorse or support any form of piracy or unauthorized distribution of copyrighted content. Using the information provided in this guide to download or distribute copyrighted material without proper authorization is strictly prohibited and against the law.

The primary goal of this setup is to help users learn how to configure and use qBittorrent, Wireguard, and Docker Compose for legitimate use cases, such as downloading open-source software, legally shared content, and personal files. Please ensure that you use this setup responsibly and in compliance with the law.

By using this guide and the provided setup, you acknowledge that you are solely responsible for your actions and any consequences arising from your usage of the information provided.
