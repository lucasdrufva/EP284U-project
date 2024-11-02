#!/bin/bash

ELASTICSEARCH_HOST="localhost:9200"
ELASTICSEARCH_USER="elastic"
ELASTICSEARCH_PASSWORD="vKmneuN1fF"
FILEBEAT_USERNAME="filebeat_user"
FILEBEAT_PASSWORD="oTCLMRVPO6"

echo "Checking if Elasticsearch is ready..."
until curl -s -u "$ELASTICSEARCH_USER:$ELASTICSEARCH_PASSWORD" "$ELASTICSEARCH_HOST" > /dev/null; do
    sleep 1
done

echo "Elasticsearch is ready, setting up Filebeat user..."
# Check if the filebeat user exists
if ! curl -s -u "$ELASTICSEARCH_USER:$ELASTICSEARCH_PASSWORD" "$ELASTICSEARCH_HOST/_security/user/$FILEBEAT_USERNAME" | grep -q '"found":true'; then
    # Create Filebeat user with necessary permissions
    curl -X POST -u "$ELASTICSEARCH_USER:$ELASTICSEARCH_PASSWORD" "$ELASTICSEARCH_HOST/_security/user/$FILEBEAT_USERNAME" -H "Content-Type: application/json" -d "
    {
        \"password\" : \"$FILEBEAT_PASSWORD\",
        \"roles\" : [ \"beats_writer\", \"monitoring_user\" ],
        \"full_name\" : \"Filebeat User\",
        \"email\" : \"filebeat@example.com\"
    }"
    echo "Filebeat user created successfully."
else
    echo "Filebeat user already exists."
fi