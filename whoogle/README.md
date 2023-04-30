# Whoogle

Whoogle is a self-hosted, ad-free search engine that acts as a proxy for Google search. It provides you with Google search results without tracking your search queries or displaying targeted ads. Whoogle is useful for those who value privacy and want to enjoy the power of Google search without compromising their personal data. To set Whoogle as your primary search engine in the browser, follow the instructions in its [repository](https://github.com/benbusby/whoogle-search#set-whoogle-as-your-primary-search-engine).

## Setup

This section provides instructions on how to set up the Whoogle container. For detailed information and additional options, please visit the official documentation: https://github.com/benbusby/whoogle-search/blob/main/README.md

### .env.example

The `.env.example` file is a template containing placeholder values that you need to fill in. After replacing the placeholders with your actual values, rename the file to `.env`. This file is essential for configuring the environment variables required by the container.

#### WHOOGLE_CONFIG_COUNTRY

This variable filters search results by hosting country. Set it to the appropriate country code (e.g., "CA" for Canada).

#### WHOOGLE_CONFIG_GET_ONLY

This variable, when set to "1", enables searching using GET requests only.

#### WHOOGLE_CONFIG_SEARCH_LANGUAGE

This variable sets the search result language. Set it to the desired language code (e.g., "lang_en").
