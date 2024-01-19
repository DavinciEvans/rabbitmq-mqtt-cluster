#!/bin/bash

# Stop the running RabbitMQ service
rabbitmq-server &
rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
# Configure mirrored queue policy if MIRROR_QUEUE environment variable is set to true
if [ "$MIRROR_QUEUE" = true ]; then
    echo "Setting up mirrored queues policy..."
    rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all","ha-sync-mode":"automatic"}'
fi

echo "Stopping RabbitMQ service..."
rabbitmqctl stop_app

# Wait for RabbitMQ to fully stop and the main node start
sleep 5

# Check if the CLUSTER_WITH environment variable is set
if [ ! -z "$CLUSTER_WITH" ]; then
    echo "Joining cluster with node: $CLUSTER_WITH"
    # Wait for main node
    sleep 20
    # If RAM_NODE is true, join the cluster as a RAM node
    if [ "$RAM_NODE" = true ]; then
        echo "Joining as a RAM node..."
        rabbitmqctl join_cluster --ram rabbit@$CLUSTER_WITH
    else
        # Join the cluster as a regular (disk) node
        rabbitmqctl join_cluster rabbit@$CLUSTER_WITH
    fi
    sleep 5
fi

echo "restart rabbitMQ"
rabbitmqctl stop
sleep 5
exec "$@"
