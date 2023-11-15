#!/bin/bash

# The Jenkins URL, username, and password
url="http://localhost:8080"
user="admin"
password="admin123*"

# URL-encode the URL
url_encoded=$(printf "%s" "$url" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')

# Get the CSRF crumb
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" "$url/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# Configure Jenkins instance
curl -X POST -u "$user:$password" "$url/setupWizard/configureInstance" \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H "Jenkins-Crumb:$only_crumb" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
  --cookie "$cookie_jar" \
  --data "rootUrl=$url_encoded%2F&json=%7B%22rootUrl%22%3A%20%22$url_encoded%2F%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D&core%3Aapply=&Submit=Save&json=%7B%22rootUrl%22%3A%20%22$url_encoded%2F%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"
