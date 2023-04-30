# Renovate Bot

Renovate Bot is an automated tool that helps developers keep their project dependencies up-to-date. It scans your project for dependencies, identifies outdated packages, and creates pull requests to update them. This makes it easier to maintain your projects and ensures that you are using the latest, most secure versions of the packages you rely on.

## How to use it

It's important to note that the Renovate Bot container is not designed to run continuously. Instead, it is meant to be executed at specific intervals to check for updates and create pull requests as needed. To achieve this, you should set up a cron job or another scheduling mechanism to spin up the Renovate container at the desired frequency. For more information on setting up cron jobs, visit the official [CronHowto](https://help.ubuntu.com/community/CronHowto) guide.

## Setup

This section provides instructions on how to set up the Renovate container. For detailed information and additional options, please visit the official documentation: https://docs.renovatebot.com/self-hosted-configuration/ and https://docs.renovatebot.com/configuration-options/

### .env.example

The `.env.example` file is a template containing placeholder values that you need to fill in. After replacing the placeholders with your actual values, rename the file to `.env`. This file is essential for configuring the environment variables required by the container.

#### DOCKER_VOLUME

This variable represents the path to the Docker volume that stores the configuration files and dependencies for the project. Replace the placeholder value with the appropriate path on your system.

#### RENOVATE_DRY_RUN

This variable determines whether Renovate Bot should perform a dry run, which means it will not create or update any actual pull requests. For the available options, refer to: https://docs.renovatebot.com/self-hosted-configuration/#dryrun.

#### RENOVATE_GIT_AUTHOR

This variable specifies the email address associated with the commit author. Provide the email address that you want to use for Renovate Bot's commits.

#### RENOVATE_GIT_PRIVATE_KEY

This variable is used to set the private GPG key for signing commits made by Renovate Bot. For more information on generating and configuring a GPG key, visit: https://docs.renovatebot.com/self-hosted-configuration/#gitprivatekey and https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key.

#### RENOVATE_LOG_LEVEL

This variable sets the log level for Renovate Bot, allowing you to control the amount of detail included in the logs. For more information on available log levels, visit: https://docs.renovatebot.com/examples/self-hosting/#about-the-log-level-numbers.

#### RENOVATE_PLATFORM

This variable defines the platform on which your repositories are hosted, such as GitHub or GitLab. For a list of supported platforms and their configuration options, visit: https://docs.renovatebot.com/self-hosted-configuration/platform.

#### RENOVATE_REPOSITORIES

This variable specifies the repositories that Renovate Bot should process. Provide a comma-separated list, including the user or organization name for each repository. For example:

```
RENOVATE_REPOSITORIES="UserName/RepoName1,UserName/RepoName2"
```

#### RENOVATE_TOKEN

This variable sets the access token that Renovate Bot will use to authenticate with the platform hosting your repositories. For more information on generating and configuring an access token, visit: https://docs.renovatebot.com/modules/platform/github/.
