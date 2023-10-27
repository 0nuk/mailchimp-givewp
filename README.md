# GiveWP to Mailchimp Integration Script

This Bash script is designed to integrate GiveWP donation data from a WordPress website with a Mailchimp audience using their respective APIs. The script retrieves donor information from GiveWP via its API and updates or adds donors to a specified Mailchimp audience.

## Prerequisites

Before using this script, ensure you have the following prerequisites in place:

- Access to a WordPress website with the GiveWP plugin installed.
- API key and token for GiveWP.
- API key for Mailchimp.
- The Mailchimp server name.
- Mailchimp audience (list) ID.

## Configuration

You need to configure the script by setting the following variables at the beginning of the script:

- `WORDPRESS_URL`: The URL of your WordPress website.
- `API_GIVEWP_KEY`: Your GiveWP API key.
- `API_GIVEWP_TOKEN`: Your GiveWP API token.
- `API_CHIMPMAIL_KEY`: Your Mailchimp API key.
- `API_CHIMPMAIL_SERVER`: The Mailchimp server name.
- `CHIMPMAIL_LIST_ID`: The ID of the Mailchimp audience (list) you want to update.

### Merge Fields in Mailchimp

You must configure merge fields in Mailchimp with the following names:

- FIRST_NAME (Type text)
- LAST_NAME (Type text)
- DONOR_ID (Type number)
- TOTAL_DONA (Type number)
- TOTAL_SPEN (Type number)

Ensure that these merge field names match the names specified in the script for proper data mapping.

## Usage

1. Set the necessary configuration variables at the beginning of the script.
2. Execute the script.
3. The script will make periodic API requests to GiveWP to retrieve donor information and then update or add donors to your Mailchimp audience.
4. The script will continue running indefinitely with a sleep interval of 3600 seconds (1 hour) between API requests.

## Contributing

If you want to contribute to this project or report issues, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

Please ensure that you handle API keys and tokens securely and follow best practices for data privacy when using this script.

