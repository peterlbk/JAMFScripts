#!/bin/zsh

# Script to get latest official Terraform version
# Since this is not possible in Installomator..

# Checking version
binary="/usr/local/bin/terraform"

# if exists check local version and newer version else check for online version
if [[ -e "$binary" ]]; then
	listing=$($binary -v)
	currentVerion=$(echo "$listing" | head -n 1 | awk '{print $2}' | tr -d v)
	onlineVersion=$(echo "$listing" | sed '5q;d' | awk '{print $2}')
fi
if [[ -z $onlineVersion ]]; then 
	echo "no local update found, checking online..."
	onlineVersion=$(curl -s https://releases.hashicorp.com/terraform/ | grep terraform | grep -v alpha | head -1 | awk -F "/" '{print $3}')
fi

if [[ "$currentVerion" != "$onlineVersion" ]]; then
	echo "updating Terraform..."
	if [[ $(arch) == i386 ]]; then
			downloadURL="https://releases.hashicorp.com/terraform/$onlineVersion/terraform_"$onlineVersion"_darwin_amd64.zip"
	elif [[ $(arch) == arm64 ]]; then
			downloadURL="https://releases.hashicorp.com/terraform/$onlineVersion/terraform_"$onlineVersion"_darwin_arm64.zip"
	fi
	echo "downloading Terraform..."
curl -fsL --show-error $downloadURL -o /tmp/terraform.zip 

unzip /tmp/terraform.zip -d /usr/local/bin/
echo "install has finished!"
else
	echo "Terraform was already up to date!"
fi