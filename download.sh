#!/bin/sh -e

export COOKIES='cookies.txt'
export USER_AGENT='Mozilla/5.0'

cd "$(dirname "$(readlink -f "$0")")"

echo > "$COOKIES"
chmod 600 "$COOKIES"

if [ -z "$ORACLE_FILE" ]; then
	phantomjs --ssl-protocol=tlsv1 download.js "$ORACLE_URL" "$ORACLE_FILE"| head -n 1 |
	curl --cookie "$COOKIES" --cookie-jar "$COOKIES" --data '@-' \
  	  --location --output "$ORACLE_FILE" --user-agent "$USER_AGENT" \
  		'https://login.oracle.com/oam/server/sso/auth_cred_submit'
	echo "Downloaded $ORACLE_FILE"
fi

if [ -z "$ORACLE_CLIENT_FILES" ]; then
	for client_file in ${ORACLE_CLIENT_FILES//:/ }; do
		phantomjs --ssl-protocol=tlsv1 download.js "$ORACLE_CLIENT_URL" "$client_file"| head -n 1 |
		curl --cookie "$COOKIES" --cookie-jar "$COOKIES" --data '@-' \
  	  	  --location --output "$ORACLE_FILE" --user-agent "$USER_AGENT" \
  			  'https://login.oracle.com/oam/server/sso/auth_cred_submit'
		echo "Downloaded $client_file"
	done
fi
