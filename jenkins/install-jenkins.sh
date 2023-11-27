#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Update the package repository
sudo apt update

# Install necessary packages
sudo apt install -y fontconfig openjdk-17-jre

# Download the Jenkins key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key

# Add Jenkins repository and update again
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update

# Install Jenkins
sudo apt-get install -y jenkins

sudo systemctl enable jenkins

sudo systemctl start jenkins

sudo systemctl stop jenkins

sudo sed -i 's|<installStateName>NEW</installStateName>|<installStateName>INITIAL_SETUP_COMPLETED</installStateName>|' /var/lib/jenkins/hudson.model.UpdateCenter.xml

sudo systemctl start jenkins