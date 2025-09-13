# Custom Filebeat Image with additional modules
# Build with: docker build -t lakehouse/custom-filebeat:latest docker-images/custom-filebeat/

FROM docker.elastic.co/beats/filebeat:8.11.0

USER root

# Install additional dependencies
RUN yum update -y && \
    yum install -y curl wget && \
    yum clean all

# Copy custom Filebeat configuration
COPY filebeat.yml /usr/share/filebeat/filebeat.yml
COPY modules.d/ /usr/share/filebeat/modules.d/

# Copy custom processors or inputs if any
COPY processors/ /usr/share/filebeat/processors/

# Set proper permissions
RUN chown -R filebeat:filebeat /usr/share/filebeat/filebeat.yml \
    /usr/share/filebeat/modules.d/ \
    /usr/share/filebeat/processors/ && \
    chmod go-w /usr/share/filebeat/filebeat.yml

USER filebeat

# Enable additional modules
RUN filebeat modules enable system nginx apache

# Setup index template and dashboards (optional)
# RUN filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["elasticsearch:9200"]'
