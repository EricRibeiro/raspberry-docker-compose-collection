# Mullvad Browser

Mullvad Browser is a pre-configured web browser that uses the Mullvad VPN to ensure your online privacy and security. Mullvad VPN is a privacy-focused virtual private network (VPN) service that encrypts your internet connection, hides your IP address, and prevents online tracking. By using the Mullvad Browser, you can browse the internet with peace of mind, knowing that your online activities are secure and private.

## Setup

This section provides instructions on how to set up the Mullvad Browser container. For detailed information and additional options, please visit the official LinuxServer.io documentation: https://docs.linuxserver.io/images/docker-mullvad-browser

### .env.example

The `.env.example` file is a template containing placeholder values that you need to fill in. After replacing the placeholders with your actual values, rename the file to `.env`. This file is essential for configuring the environment variables required by the container.

#### DOCKER_VOLUME

This variable represents the path to the Docker volume that stores the configuration files and dependencies for the project. Replace the placeholder value with the appropriate path on your system.
