#!/bin/zsh

localversion=$(aws --version | awk '{print $1}' | awk -F "/" '{print $2}')
onlineversion=$(curl -s https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst | sed '5q;d')

if [[ ${localversion} != ${onlineversion} ]]; then
	echo "updating awscli2..."
	jamf policy -event awscli2
else
	echo "awscli2 is up to date!"
fi
