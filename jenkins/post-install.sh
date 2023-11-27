#!/bin/bash

# The Jenkins URL, username, and password
url="http://localhost:8080"
user="admin"
password="admin123*"

#Install Jenkins Cli
wget http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth "$user":"$password" install-plugin workflow-aggregator cloudbees-folder
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth "$user":"$password" safe-restart

sleep 30

# URL-encode the URL
url_encoded=$(printf "%s" "$url" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')

# Get the CSRF crumb
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" "$url/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# Folder name and URL-encode it
folder_name="Samples"
folder_name_encoded=$(printf "%s" "$folder_name" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')
pipeline_name="HelloWorld"

# Create a folder
curl -X POST -u "$user:$password" "$url/createItem" \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H "Jenkins-Crumb:$only_crumb" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
  --cookie "$cookie_jar" \
  --data "name=$folder_name_encoded&mode=com.cloudbees.hudson.plugins.folder.Folder&Submit=OK"


sleep 5 

#Create Jenkins pipeline
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:admin123* create-job "$folder_name"/"${pipeline_name}" < HelloWorld.xml