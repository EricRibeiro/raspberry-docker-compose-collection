# Autobrr

Autobrr is an open-source tool designed for automating the process of downloading and seeding files. It allows users to set up rules for automatic downloads and manages torrent seeding to help maintain a healthy upload/download ratio. Autobrr is particularly useful for users who participate in private torrent communities where maintaining a good ratio is crucial. Features include the ability to monitor several torrent sites, support for multiple download clients, and customizable actions based on torrent announcements.

## Setup

Below is a brief overview of the setup process for Autobrr.

### .env.example

The `.env.example` file serves as a template with placeholder values that need to be customized. You should replace these placeholders with your specific configuration details and then rename the file to `.env`. This step is crucial as the `.env` file configures the environment variables required for the application to run properly.

#### DOCKER_VOLUME

This variable specifies the path to the Docker volume where Autobrr stores its data, including configuration files and other dependencies. You need to replace the placeholder with the correct path on your system.

#### DOCKER_SEED_VOLUME

The `DOCKER_SEED_VOLUME` variable specifies the path to the seed volume so the container can check available space. It is important to set this path correctly to ensure that Autobrr can manage its seeding responsibilities effectively.

### Updating script paths

Ensure to modify the path of the variable `seedVolume` in `scripts/freespace.sh` to match the `DOCKER_SEED_VOLUME` value. This step ensures that the script correctly checks the free space on the seed volume as intended.
