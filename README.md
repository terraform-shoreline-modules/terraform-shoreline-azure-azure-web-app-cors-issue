
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Azure Web App CORS Issue
---

Cross-Origin Resource Sharing (CORS) issues can occur when a web application tries to make requests to a different domain than the one it originated from. This can lead to unexpected behavior, security errors, or blocked API calls. CORS issues can prevent web pages from functioning properly and can be a common issue for web developers and software engineers.

### Parameters
```shell
export WEB_APP_NAME="PLACEHOLDER"

export RESOURCE_GROUP_NAME="PLACEHOLDER"

export CERTIFICATE_NAME="PLACEHOLDER"

export NSG_NAME="PLACEHOLDER"

export NSG_RULE_NAME="PLACEHOLDER"

export CLIENT_DOMAIN="PLACEHOLDER"
```

## Debug

### Check if the web app is running
```shell
az webapp show --name ${WEB_APP_NAME} --resource-group ${RESOURCE_GROUP_NAME} --query state
```

### Check if the web app's logs reveal any CORS-related errors
```shell
az webapp log tail --name ${WEB_APP_NAME} --resource-group ${RESOURCE_GROUP_NAME} 
```

### Check if the web app's SSL certificate is valid and installed correctly
```shell
az webapp config ssl show --certificate-name ${CERTIFICATE_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

### Check if the web app's network traffic is being blocked by a firewall
```shell
az network nsg rule show --resource-group ${RESOURCE_GROUP_NAME} --nsg-name ${NSG_NAME} --name ${NSG_RULE_NAME}
```

### Check if CORS is enabled on the web app
```shell
az webapp cors show --name ${WEB_APP_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

## Repair

### Update and ensure that the correct headers are being set. Specifically, the Access-Control-Allow-Origin header should be set to allow requests from the client's domain.
```shell
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


```