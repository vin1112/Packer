#!/bin/bash

# Set your Jenkins URL and password
url=http://localhost:8080
password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

# Set the admin user information
username="admin"
new_password="admin123*"
full_name="admin 01"

# URL-encode the values
encoded_username=$(printf "%s" "$username" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')
encoded_new_password=$(printf "%s" "$new_password" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')
encoded_full_name=$(printf "%s" "$full_name" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')

# GET THE CRUMB AND COOKIE
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "admin:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# MAKE THE REQUEST TO CREATE AN ADMIN USER
curl -X POST -u "admin:$password" $url/setupWizard/createAdminUser \
        -H "Connection: keep-alive" \
        -H "Accept: application/json, text/javascript" \
        -H "X-Requested-With: XMLHttpRequest" \
        -H "$full_crumb" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --cookie $cookie_jar \
        --data-raw "username=$encoded_username&password1=$encoded_new_password&password2=$encoded_new_password&fullname=$encoded_full_name&Jenkins-Crumb=$only_crumb&json=%7B%22username%22%3A%20%22$encoded_username%22%2C%20%22password1%22%3A%20%22$encoded_new_password%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$encoded_new_password%22%2C%20%22fullname%22%3A%20%22$encoded_full_name%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D&core%3Aapply=&Submit=Save&json=%7B%22username%22%3A%20%22$encoded_username%22%2C%20%22password1%22%3A%20%22$encoded_new_password%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$encoded_new_password%22%2C%20%22fullname%22%3A%20%22$encoded_full_name%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"
