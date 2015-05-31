#!/bin/sh -e

ORACLE_RPM=`basename $ORACLE_FILE .zip`

cd "$(dirname "$(readlink -f "$0")")"

sudo apt-get -qq update
sudo apt-get --no-install-recommends -qq install alien bc libaio1 unzip

if [ -n "$ORACLE_CLIENT_FILES" ]; then
	for client_file in ${ORACLE_CLIENT_FILES//:/ }; do
		sudo dpkg --install `sudo alien --scripts --to-deb "$client_file" | cut -d' ' -f1`
	done
fi

if [ -n "$ORACLE_FILE" ]; then
	setup_oracle_xi.sh
fi
