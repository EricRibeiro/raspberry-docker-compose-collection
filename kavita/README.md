# Kavita

Kavita is an open-source digital library server designed specifically for comics and manga. It provides an optimized experience for readers through features such as bookmarking, tracking reading progress, and detailed metadata management. Kavita supports a wide range of file formats, making it a versatile choice for managing your digital collection.

## Setup

This section provides instructions on how to set up the Kavita container. For detailed information and additional options, please visit the official Kavita documentation: https://github.com/Kareadita/Kavita

### .env.example

The `.env.example` file is a template containing placeholder values that you need to replace with your actual values. After modifying the file, rename it to `.env`. This file is essential for configuring the environment variables required by the container.

#### DOCKER_VOLUME

This variable defines the storage path for Kavita's volume. It relies on the `${DOCKER_VOLUME_ROOT}` variable set in `global.env`. Replace the placeholder with the appropriate path on your system where the Kavita volume should reside.

#### DOCKER_COMICS_VOLUME

This variable specifies the path on your host machine where your comics are stored. The path provided here will be mapped to the container so that Kavita can access and manage your comics collection.

#### DOCKER_MANGA_VOLUME

Similar to `DOCKER_COMICS_VOLUME`, this variable sets the path on your host machine where your manga are stored. This ensures that your manga collection is accessible within the Kavita environment.

#### KAVITA_API_KEY

This variable is used to authenticate `komf` with the Kavita API, which is necessary for certain operations within the application. Replace `your_kavita_api_key` with the actual API key provided to you by Kavita.

#### MYANIMELIST_CLIENT_ID

This variable is for integrating with MyAnimeList via the `komf` service, which is used for metadata retrieval. Replace `your_myanimelist_client_id` with the client ID provided by MyAnimeList.

### Komf Usage

`komf` is integrated into the Kavita setup for managing and retrieving metadata. Here are some API endpoints provided by `komf`:

#### Match Individual Series

```
POST /kavita/match/library/{libraryId}/series/{seriesId}
```

Attempts to match the specified series within a specific library in Kavita.

#### Match All Series in a Library

```
POST /kavita/match/library/{libraryId}
```

Attempts to match all series within a specific library.

#### Reset Metadata for Individual Series

```
POST /kavita/reset/library/{libraryId}/series/{seriesId}
```

Resets all metadata for a specific series in Kavita.

#### Reset Metadata for All Series in a Library

```
POST /kavita/reset/library/{libraryId}
```

Resets all metadata for all series within a library.

These endpoints are useful for maintaining accurate metadata for your library. You can find `libraryId` and `seriesId` in the URL when a series is opened in Kavita, for example:

```
https://kavita.traefik.ca/library/1/series/2
```
