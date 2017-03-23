# apache-flink-jdbc-streaming
Sample project for Apache Flink with Streaming Engine and JDBC Sink.
Contains a test class that starts a local kafka broker. 

## Setting
```
[[Source(Protobuf)] -> [Sink(Kafka)]] 
   |
   |   
[Kafka]
   |
   |   
[[Source (Kafka) -> Map(Protobuf, Row) -> Sink(JDBC)]]  
``` 

# Requirements
You need a running database. I used a mysql docker image:

```
docker run -it --link mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
```

# Quick start
1. Run KafkaProducerIT test in order to start a local kafka broker
2. Run TrackingEventProducer main class that publishes events to a kafka topic
3. Run TrackingEventConsumer main class that consumes events from topic and writes them to the configured database (this is the actual application)

Inspired by johnnypark