#!/bin/bash

# Kafka Connect Initialization Script
set -e

echo "Installing Debezium PostgreSQL connector..."
confluent-hub install --no-prompt debezium/debezium-connector-postgresql:2.4.0

echo "Installing MinIO/S3 connector..."
confluent-hub install --no-prompt confluentinc/kafka-connect-s3:10.5.0

echo "Installing Elasticsearch connector..."
confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:14.0.10

echo "Launching Kafka Connect worker..."
exec /etc/confluent/docker/run &

echo "Waiting for Kafka Connect to start listening on kafka-connect:8083 ⏳"
while : ; do
  curl_status=$(curl -s -o /dev/null -w %{http_code} http://kafka-connect:8083/connectors)
  echo -e $(date) " Kafka Connect listener HTTP state: " $curl_status " (waiting for 200)"
  if [ $curl_status -eq 200 ] ; then
    break
  fi
  sleep 5
done

echo -e "\n--\n+> Kafka Connect is ready for connector creation"

# Keep the process running
sleep infinity
