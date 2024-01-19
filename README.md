# rabbitMQ MQTT Cluster

This docker file is built based on the official RabbitMQ image file, with MQTT turned on and environment variables for the cluster added.

docker hub: [https://hub.docker.com/repository/docker/davincievans/rabbitmq-mqtt-cluster/general](https://hub.docker.com/repository/docker/davincievans/rabbitmq-mqtt-cluster/general)

## Quick Start

This docker image is primarily used for cluster deployments, so we recommend that you use docker compose to start your application.

We have added three new environment variables to the original official ones:

- CLUSTER_WITH: indicates the node you need to connect to.

- RAM_NODE: whether to enable RAM mode, otherwise it defaults to disk.

- MIRROR_QUEUE: whether to enable mirror clustering, if so, it will synchronise all messages from the current node to other nodes.

By default 3 nodes are started up this way:

```
version: '3.7'
services:
  rabbit1:
    image: "davincievans:rabbitmq-mqtt-cluster-3.12"
    hostname: rabbit1
    environment:
      RABBITMQ_ERLANG_COOKIE: "unique_cookie"
      RABBITMQ_DEFAULT_USER: "admin"
      RABBITMQ_DEFAULT_PASS: "password"
      MIRROR_QUEUE: true
    networks:
      - rabbitmq-network

  rabbit2:
    image: "davincievans:rabbitmq-mqtt-cluster-3.12"
    hostname: rabbit2
    environment:
      RABBITMQ_ERLANG_COOKIE: "unique_cookie"
      RABBITMQ_DEFAULT_USER: "admin"
      RABBITMQ_DEFAULT_PASS: "password"
      CLUSTER_WITH: rabbit1
      RAM_NODE: true
      MIRROR_QUEUE: true
    networks:
      - rabbitmq-network
    depends_on:
      - rabbit1

  rabbit3:
    image: "davincievans:rabbitmq-mqtt-cluster-3.12"
    hostname: rabbit3
    environment:
      RABBITMQ_ERLANG_COOKIE: "unique_cookie"
      RABBITMQ_DEFAULT_USER: "admin"
      RABBITMQ_DEFAULT_PASS: "password"
      CLUSTER_WITH: rabbit1
      MIRROR_QUEUE: true
    networks:
      - rabbitmq-network
    depends_on:
      - rabbit1

networks:
  rabbitmq-network:
    driver: bridge
```

You can also use it with haproxy by referring to the docker-compose.yml file above
