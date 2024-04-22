#!/bin/bash

function get-azure-credentials {
    # Get the subscription ID and tenant ID
    SUBSCRIPTION_ID=$(az account show --query id -o tsv)
    TENANT_ID=$(az account show --query tenantId -o tsv)

    # Set the environment variables
    export AZURE_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
    export AZURE_TENANT_ID=$TENANT_ID

    # Print the environment variables
    echo "AZURE_SUBSCRIPTION_ID: $AZURE_SUBSCRIPTION_ID"
    echo "AZURE_TENANT_ID: $TENANT_ID"
}

get-azure-credentials
