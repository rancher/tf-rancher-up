#!/bin/bash

token_key="$1"
token_secret="$2"
cluster_endpoint="$3"
cluster_id="$4"
timeout=$((30*60))  # Timeout in seconds (30 minutes)

start_time=$(date +%s)

while true; do
    current_time=$(date +%s)
    elapsed_time=$((current_time - start_time))

    if [ $elapsed_time -ge $timeout ]; then
        echo "Timeout: Cluster creation took longer than 30 minutes"
        exit 1
    fi

    cluster_status=$(curl -sk -H "Authorization: Bearer ${token_key}:${token_secret}" -X GET -H 'Accept: application/json' -H 'Content-Type: application/json' ${cluster_endpoint}/v3/clusters/${cluster_id})
    
    if [[ "${cluster_status}" == *"\"state\":\"active\""* ]]; then
        echo "Cluster created successfully"
        break
    else
        echo "Cluster is still not active, waiting..."
        sleep 300
    fi
done

