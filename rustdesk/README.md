# RustDesk

RustDesk is an open-source remote desktop software that offers a secure and efficient way to access and control computers remotely. It is particularly useful for individuals and organizations seeking a reliable and cost-effective solution for remote support, remote access to personal or work computers, and collaborative work.

RustDesk stands out for its ease of use, low latency, and high-quality video streaming, making it an excellent choice for various remote desktop needs. Whether for providing technical support, accessing files and applications on a remote computer, or collaborating with team members across different locations, RustDesk offers a versatile and user-friendly platform for seamless remote connectivity.

## Setup

This section provides a brief introduction to the setup process.

### Environment Variables

Before starting, you need to set up your environment variables. Copy the `.env.example` file to a new file named `.env` and fill in the values as per your setup. The key variable to set is:

- `DOCKER_VOLUME`: This specifies the path to the RustDesk Docker volume. It will be used to store configuration files and other necessary data.

### Docker Compose Configuration

The `docker-compose.yml` file contains the necessary configuration to run RustDesk. One important aspect of this setup is the handling of encrypted connections. By default, the configuration blocks unencrypted connections to the server. This is achieved through the `-k _` parameter in the command:

```yaml
command: hbbs -r rustdesk-server.traefik.ca:21117 -k _
```

### Handling Encryption

If you wish to allow unencrypted connections, you need to modify the command in the `docker-compose.yml` file by removing the `-k _` parameter. The modified command should look like this:

```yaml
command: hbbs -r rustdesk-server.traefik.ca:21117
```

### Key Generation and Usage

RustDesk uses a unique key format for encrypted connections. The keys do not follow the conventional ed25519 format, and the exact method of their creation is not specified. However, you can find examples of how these keys look in the `data` folder:

- `id_ed25519.example` (private key)
- `id_ed25519.pub.example` (public key)

If you do not provide these keys on the first run, they will be automatically created and stored in the `DOCKER_VOLUME`. You can then copy them from there for future use.

### Setting the Public Key on the Client

To establish a connection to your RustDesk server, you need to set the public key on the client side. This key must be entered in the key field as described in the [RustDesk documentation](https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/install/#step-3-set-hbbshbbr-address-on-client-side).
