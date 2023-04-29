# Plex

Plex is a powerful media server that allows you to organize, stream, and share your multimedia content across multiple devices. It is useful because it provides a centralized solution for managing and enjoying your media library, whether it be movies, TV shows, music, or photos.

## Setup

This section provides instructions to set up the Plex Docker container. For detailed information, please refer to the image's documentation page at [LinuxServer.io](https://docs.linuxserver.io/images/docker-plex) and [TRaSH's guide](https://trash-guides.info/Plex/).

### env.example

The `env.example` file is a template containing placeholder values that you need to fill in. After replacing the placeholders with your actual values, rename the file to `.env`. This file is essential for configuring the environment variables required by the Docker containers.

#### DOCKER_DATA_VOLUME

This variable defines the location where the Plex context will be stored. I recommend following [TRaSH's guide](https://trash-guides.info/Hardlinks/How-to-setup-for/Docker/) for instructions on setting this up correctly to ensure proper storage configuration.

It's important to note that, for hardlinks to work, the files must be in the same file system. This means you cannot have downloads in Storage A hardlinked to Storage B. This is necessary because hardlinks share the same inode and data blocks on the same file system, ensuring efficient storage usage and management.

#### DOCKER_TRANSCODE_VOLUME

Using RAM for transcoding is beneficial because it speeds up the process and reduces I/O operations. Since transcode data is temporary and doesn't need to be written to a disk, leveraging RAM directories for transcoding is a smart choice. By default, Linux allocates a maximum of 50% of the total system RAM to any RAM directories (e.g., /tmp, /dev/shm). Therefore, it is recommended to mount RAM directories for transcoding.

The default value `/tmp/plex` in the example should be sufficient for most users and doesn't need to be changed unless you have specific requirements.

#### CLAIM_TOKEN

The Plex claim token is a unique identifier that helps link your Plex server to your Plex account. It is necessary for the initial setup of the container, ensuring a seamless connection between your server and account. The claim token is only required the first time the container is started.

You can obtain the claim token from the following link: [https://www.plex.tv/claim/](https://www.plex.tv/claim/). Please note that the token is only valid for 4 minutes, so you need to use it promptly to avoid any issues during setup.
