bash

#!/bin/bash



# Set variables

resource_group=${RESOURCE_GROUP_NAME}

webapp_name=${WEB_APP_NAME}

client_domain=${CLIENT_DOMAIN}



# Get the current CORS settings for the web app

cors_settings=$(az webapp cors show -g $resource_group -n $webapp_name --output json)



# Check if the Access-Control-Allow-Origin header is set correctly

if [ -n "$(echo "$cors_settings" | grep -E 'allowedOrigins":\s*\[')" ]; then

  echo "Access-Control-Allow-Origin header is set correctly."

else

# Set the Access-Control-Allow-Origin header to allow requests from the client's domain

  az webapp cors add -g $resource_group -n $webapp_name --allowed-origins $client_domain

  echo "Access-Control-Allow-Origin header has been updated."

fi