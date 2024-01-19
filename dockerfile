FROM rabbitmq:3-management

ADD handle_cluster.sh /opt/rabbit/
RUN chmod a+x /opt/rabbit/handle_cluster.sh
RUN rabbitmq-plugins enable rabbitmq_mqtt rabbitmq_web_mqtt

EXPOSE 1883 15675
ENTRYPOINT ["/opt/rabbit/handle_cluster.sh"]

CMD ["rabbitmq-server"]
