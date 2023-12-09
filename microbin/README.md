# Microbin

Microbin is an efficient and user-friendly pastebin alternative, designed for sharing snippets of text and code with ease. Built as an open-source solution, it allows for quick and secure sharing of information, with features like auto-expiry, editability, syntax highlighting, and more. Microbin is perfect for those seeking a reliable and customizable tool for sharing code snippets and text.

To effectively use Microbin, you should have Docker installed on your system, as Microbin runs in a Docker container for easy deployment and management. If you haven't installed Docker yet, refer to the official [Docker installation guide](https://docs.docker.com/engine/install/).

## Setup

This section will guide you through the initial setup process for Microbin.

### .env.example

The `.env.example` file serves as a template for setting up your environment variables. It contains various placeholders that you'll need to customize according to your setup. Once you've filled in your specific values, rename the file to `.env`. This file is crucial for configuring the necessary environment variables for Microbin.

#### Configuration Variables

- **DOCKER_VOLUME**: Specify the path to the Docker volume where Microbin's configuration files and dependencies will be stored. For example, `DOCKER_VOLUME=${DOCKER_VOLUME_ROOT}/microbin`.
- **MICROBIN_DEFAULT_BURN_AFTER**: Sets the default burn-after-read setting for pastes (0 to disable).
- **MICROBIN_DEFAULT_EXPIRY**: Determines the default expiration time for pastes (e.g., `24hour`).
- **MICROBIN_EDITABLE**: Enables or disables the editability of pastes (`true` or `false`).
- **MICROBIN_ENABLE_BURN_AFTER**: Allows the use of burn-after-read feature (`true` or `false`).
- **MICROBIN_ENABLE_READONLY**: Enables the creation of read-only pastes (`true` or `false`).
- **MICROBIN_GC_DAYS**: Sets the number of days after which garbage collection for expired pastes will occur.
- **MICROBIN_HASH_IDS**: Enable or disable hashing of paste IDs (`true` or `false`).
- **MICROBIN_HIGHLIGHTSYNTAX**: Turn on syntax highlighting for pastes (`true` or `false`).
- **MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB**: Sets the maximum file size for unencrypted uploads, in megabytes.
- **MICROBIN_NO_FILE_UPLOAD**: Disables file uploads if set to `true`.
- **MICROBIN_PRIVATE**: Defines whether the instance is private (`true`) or public.
- **MICROBIN_SHOW_READ_STATS**: Display read statistics for pastes (`true` or `false`).
