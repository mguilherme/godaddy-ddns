#!/bin/bash

# Check and update your GoDaddy DNS server to the IP address of your current internet connection.
# First go to GoDaddy developer site to create a developer account and get your key and secret.
#
# https://developer.godaddy.com/getstarted
# Be aware that there are 2 types of key and secret - one for the test server and one for the production server
# Get a key and secret for the production server
# 

if [ $# -ne 2 ]; then
  echo "Usage: $0 <A_RECORD> <DOMAIN_NAME>"
  exit 1
fi

# Set A record and domain to values specified by user

name=$1    # name of A record to update
domain=$2  # your domain

# Modify the next two lines with your key and secret
key=""      # key for godaddy developer API
secret=""   # secret for godaddy developer API

headers="Authorization: sso-key $key:$secret"
#echo "Headers: " $headers

providerData=$(curl -s -X GET -H "$headers" "https://api.godaddy.com/v1/domains/$domain/records/A/$name")
#echo "Provider data: " $providerData


dnsIp=$(echo $providerData | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
#echo "DNS Ip:" $dnsIp

# Get public ip address, there are several websites that can do this.
ipInfo=$(curl -s GET "http://ipinfo.io/json")
currentIp=$(echo $ipInfo | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
#echo "currentIp:" $currentIp


if [ ${dnsIp} != ${currentIp} ]; then

  echo $(date +"[%d-%m-%Y - %H:%M:%S] - $name.$domain -> $currentIp")

  requestData='[{"data":"'$currentIp'","ttl":600}]'
#  echo $request

  response=$(curl -i -s -X PUT \
    -H "$headers" \
    -H "Content-Type: application/json" \
    -d $requestData "https://api.godaddy.com/v1/domains/$domain/records/A/$name")
#  echo $response

fi
