#!/bin/bash

set -euo pipefail

# Wordpress website URL
WORDPRESS_URL=""
# Givewp API key
API_GIVEWP_KEY=""
# Givewp API token
API_GIVEWP_TOKEN=""
# Chimpmail API key
API_CHIMPMAIL_KEY=""
# Chimpmail server name
API_CHIMPMAIL_SERVER=""
# Chimpmail audience (list) ID
CHIMPMAIL_LIST_ID=""

# URL for givewp API request
API_GIVEWP_URL="$WORDPRESS_URL/give-api/v1/donors/?key=$API_GIVEWP_KEY&token=$API_GIVEWP_TOKEN&number=-1"
# URL for chimpmail API request
API_CHIMPMAIL_URL="https://$API_CHIMPMAIL_SERVER.api.mailchimp.com/3.0/lists/$CHIMPMAIL_LIST_ID/members/"

while true; do
	# Make a GET request to the API and store the response in a variable
	json_response=$(curl -s "$API_GIVEWP_URL")

	# Check if the request was successful, otherwise display the error and exit the program
	if [ $? -ne 0 ]; then
		echo "Error making the API request."
		exit 1
	fi

	# Extract values of donor_id, first_name, last_name, email, total_donations, total_spent from the JSON without using jq since it's not available on the hosting server.
	donors=$(echo "$json_response" | grep -o '"donor_id": "[^"]*"\|"first_name": "[^"]*"\|"last_name": "[^"]*"\|"email": "[^"]*"\|"total_donations": "[^"]*"\|"total_spent": "[^"]*"')
	donor_info=()
	while read -r line; do
		donor_info+=("$line")
	done <<< "$donors"

	# Iterate through the array of donors and send them to the Chimpmail API (Update if the donor already exists)
	for ((i = 0; i < ${#donor_info[@]}; i += 6)); do
		donor_id=$(echo "${donor_info[i]}" | cut -d'"' -f4)
		first_name=$(echo "${donor_info[i + 1]}" | cut -d'"' -f4)
		last_name=$(echo "${donor_info[i + 2]}" | cut -d'"' -f4)
		email=$(echo "${donor_info[i + 3]}" | cut -d'"' -f4)
		total_donations=$(echo "${donor_info[i + 4]}" | cut -d'"' -f4)
		total_spent=$(echo "${donor_info[i + 5]}" | cut -d'"' -f4)

		curl -sS --request PUT \
		--url "$API_CHIMPMAIL_URL$email" \
		--user "key:$API_CHIMPMAIL_KEY" \
		--header 'content-type: application/json' \
		--data @- \
		<<EOF
		{
			"email_address": "$email",
			"status_if_new":"subscribed",
			"merge_fields": {
				"FIRST_NAME": "$first_name",
				"LAST_NAME": "$last_name",
				"DONOR_ID": "$donor_id",
				"TOTAL_DONA": "$total_donations",
				"TOTAL_SPEN": "$total_spent"
			}
		}
EOF
	done
	sleep 3600
done
