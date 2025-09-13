# Custom Flink Job Image
# Build with: docker build -t lakehouse/flink-job:latest docker-images/flink-job/

FROM flink:1.18-java11

# Install additional dependencies if needed
USER root

# Add custom Kafka connectors and dependencies
RUN mkdir -p /opt/flink/lib-custom && \
    curl -L -o /opt/flink/lib-custom/flink-sql-connector-kafka-1.18.0.jar \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-kafka/1.18.0/flink-sql-connector-kafka-1.18.0.jar && \
    curl -L -o /opt/flink/lib-custom/flink-sql-connector-elasticsearch7-1.18.0.jar \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-elasticsearch7/1.18.0/flink-sql-connector-elasticsearch7-1.18.0.jar

# Copy custom job JARs
COPY jobs/*.jar /opt/flink/jobs/

# Copy custom configuration
COPY conf/ /opt/flink/conf-custom/

# Set proper permissions
RUN chown -R flink:flink /opt/flink/lib-custom /opt/flink/jobs /opt/flink/conf-custom

USER flink

# Optional: Set custom Flink configuration
ENV FLINK_PROPERTIES="jobmanager.rpc.address: flink-jobmanager\n\
taskmanager.numberOfTaskSlots: 4\n\
parallelism.default: 2\n\
state.backend: filesystem\n\
state.checkpoints.dir: file:///tmp/flink-checkpoints\n\
execution.checkpointing.interval: 60000"
