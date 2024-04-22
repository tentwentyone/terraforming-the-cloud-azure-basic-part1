#!/bin/bash

function get-azure-credentials {
    # Get the subscription ID and tenant ID
    SUBSCRIPTION_ID=$(az account show --query id -o tsv)
    TENANT_ID=$(az account show --query tenantId -o tsv)

    # Set the environment variables
    export TF_VAR_subscription_id=$SUBSCRIPTION_ID
    export TF_VAR_tenant_id=$TENANT_ID

    # Print the environment variables
    echo "AZURE_SUBSCRIPTION_ID: $TF_VAR_subscription_id"
    echo "AZURE_TENANT_ID: $TF_VAR_tenant_id"
}

get-azure-credentials