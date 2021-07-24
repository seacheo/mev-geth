#!/bin/sh
# Starts metabase

get_db_password() {
	# Check to make sure instance role is properly set
	cat /root/.profile
	# Loads the Metabase RDS password from SSM
	echo "Retrieving database password..."
	export MB_DB_PASS=`aws --region=$region ssm get-parameters \
		--name /flashbots/metabase/password \
		--with-decryption \
		--output text \
		--query 'Parameters[*].Value'`
	if [ $? -ne 0 ]
	then
		echo "SSM Error retrieving database password."
		exit 1
	fi
}

set_hostname() {
	HOSTNAME=`cat /etc/hostname`
	echo "HOSTNAME: ${HOSTNAME}"
	echo "${HOSTNAME} 127.0.0.1" >> /etc/hosts
}

start_metabase() {
	exec bash -c /app/run_metabase.sh
}

# main

get_db_password
set_hostname
start_metabase
