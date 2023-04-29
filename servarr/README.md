# Servarr Apps Docker Compose Repository

## Servarr

Servarr apps are a suite of applications that work together to automate and manage various aspects of your media library, such as downloading, organizing, and renaming TV shows, movies, and music. They are useful for maintaining a well-organized and up-to-date media library with minimal manual intervention. This repository provides a docker-compose file that sets up three popular Servarr apps: Prowlarr, Radarr, and Sonarr.

### Sonarr

Sonarr is a TV series management tool that automates the process of downloading and organizing your favorite TV shows. It integrates with various download clients, such as NZBGet, SABnzbd, and qBittorrent, and can monitor RSS feeds for new episodes of the shows you follow. Sonarr's primary benefit is its ability to automate the downloading and organization of TV shows, saving you time and ensuring your media library is always up-to-date.

### Radarr

Radarr is a movie collection manager designed to automate the downloading and organization of movies. Like Sonarr, Radarr integrates with various download clients and can monitor RSS feeds for new movie releases. The key advantage of Radarr is that it streamlines the process of acquiring and organizing movies, keeping your media library organized and updated with minimal effort on your part.

### Prowlarr

Prowlarr is a meta-indexer and search tool that consolidates multiple indexers and torrent trackers, providing a single, unified interface for searching and managing your media sources. Prowlarr simplifies the process of discovering new content and integrating with other Servarr apps, like Sonarr and Radarr, making it easier to find, download, and manage media files.

## Setup

The following subsections provide guidance on setting up the containers for each Servarr app. For more detailed information on each app, please visit the Servarr wiki at https://wiki.servarr.com/ or the container documentation pages for [Sonarr](https://docs.linuxserver.io/images/docker-sonarr), [Radarr](https://docs.linuxserver.io/images/docker-radarr), and [Prowlarr](https://docs.linuxserver.io/images/docker-prowlarr).

### .env.example

The `.env.example` file is a template containing placeholder values that you need to fill in. After replacing the placeholders with your actual values, rename the file to `.env`. This file is essential for configuring the environment variables required by the container.

#### DOCKER_VOLUME

This variable represents the path to the Docker volume that stores the configuration files and dependencies for the project. Replace the placeholder value with the appropriate path on your system.

#### DOCKER_DATA_VOLUME

This folder should contain the data for the Servarr apps. Please read TRaSH's [Docker setup guide](https://trash-guides.info/Hardlinks/How-to-setup-for/Docker/) and Servarr's [Docker guide](https://wiki.servarr.com/docker-guide) for more information on properly setting up the data folder for your Servarr apps.

## Legal Disclaimer

This repository and the associated applications are provided for educational and informational purposes only. The maintainers of this repository do not endorse or promote any illegal activities related to copyrighted content. It is the user's responsibility to ensure that they are using these applications in accordance with their local laws and regulations. By using this repository, you acknowledge and agree to this disclaimer and assume full responsibility for your actions.
