#!/bin/bash

# Update package list
sudo apt-get update

# Install OpenJDK 11
sudo apt-get install openjdk-11-jdk -y

# Create tools directory in /home/
cd /home/ && mkdir tools && cd tools


# Download Apache JMeter
wget https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-5.5.tgz

# Extract the downloaded archive
tar -xvf apache-jmeter-5.5.tgz

# Remove the downloaded archive
rm -rf apache-jmeter-5.5.tgz

# Create a directory for JMeter scripts
mkdir /home/jmeterScripts

# Change to the JMeter scripts directory
cd /home/jmeterScripts || exit

echo "Apache JMeter has been successfully installed."


# Install InfluxDB
wget https://dl.influxdata.com/influxdb/releases/influxdb2-2.7.1-amd64.deb
sudo dpkg -i influxdb2-2.7.1-amd64.deb
sudo service influxdb start

# Install Grafana
sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo systemctl start grafana-server

echo "InfluxDB and Grafana have been successfully installed."


sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

echo "Jenkins have been successfully installed."


wget https://dl.influxdata.com/influxdb/releases/influxdb2-client-2.7.3-linux-amd64.tar.gz
tar xvzf influxdb2-client-2.7.3-linux-amd64.tar.gz

sudo cp influx /usr/local/bin/

influx setup \
  --org delivery-excellence \
  --bucket delivery-excellence-bucket \
  --username delivery-excellence-user \
  --password j2ULzRnRsUkWSXB \
  --force


# Command to get InfluxDB token for the specified user
token=$(influx auth list | awk '/delivery-excellence-user/ {print $4}')

# Check if the token is not empty
if [ -z "$token" ]; then
    echo "Error: Unable to retrieve the InfluxDB token for example-user."
    exit 1
fi

# Destination directory for Grafana provisioning
grafana_provisioning_dir="/etc/grafana/provisioning/datasources"

# Create the directory if it doesn't exist
mkdir -p "$grafana_provisioning_dir"

# Generate the YAML configuration file
cat > "$grafana_provisioning_dir/grafana_config.yml" <<EOF
apiVersion: 1

datasources:
  - name: InfluxDB_Flux
    type: influxdb
    access: proxy
    url: http://localhost:8086
    jsonData:
      version: Flux
      organization: delivery-excellence
      defaultBucket: jmeter
      tlsSkipVerify: false
    secureJsonData:
      token: $token
EOF

echo "Configuration file 'grafana_config.yml' created with the InfluxDB token for example-user."

sudo systemctl restart grafana-server

cd /home/tools/apache-jmeter-5.5/lib/ext

wget https://github.com/mderevyankoaqa/jmeter-influxdb2-listener-plugin/releases/download/v2.7/jmeter-plugins-influxdb2-listener-2.7.jar

