# ChangeDetection.io

ChangeDetection.io is an open-source tool for monitoring changes on websites. It provides an intuitive way to track changes on web pages and receive notifications when updates occur. This solution is ideal for users who need to keep an eye on content updates without manually checking sites. Features include regular monitoring, customizable notification settings, and support for various notification channels like email, webhook, and more.

## Setup

Below is a brief overview of the setup process for ChangeDetection.io.

### .env.example

The `.env.example` file serves as a template with placeholder values that need to be customized. You should replace these placeholders with your specific configuration details and then rename the file to `.env`. This step is crucial as the `.env` file configures the environment variables required for the application to run properly.

#### DOCKER_VOLUME

This variable specifies the path to the Docker volume where ChangeDetection.io stores its data, including configuration files and any other dependencies. You need to replace the placeholder with the correct path on your system.

#### HIDE_REFERER

The `HIDE_REFERER` variable is used to control the referer header sent in requests made by ChangeDetection.io. Setting this to `true` can help in hiding the source of the web page requests from the target server, which is useful for privacy or avoiding detection by certain web servers. Ensure to set this according to your privacy needs.
