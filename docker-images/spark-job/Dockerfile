# Custom Spark Job Image with Iceberg support
# Build with: docker build -t lakehouse/spark-job:latest docker-images/spark-job/

FROM bitnami/spark:3.5

USER root

# Install additional packages
RUN apt-get update && \
    apt-get install -y curl wget && \
    rm -rf /var/lib/apt/lists/*

# Add Iceberg and other Lakehouse dependencies
RUN curl -L -o /opt/bitnami/spark/jars/iceberg-spark-runtime-3.5_2.12-1.4.2.jar \
    https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/1.4.2/iceberg-spark-runtime-3.5_2.12-1.4.2.jar && \
    curl -L -o /opt/bitnami/spark/jars/aws-java-sdk-bundle-1.12.262.jar \
    https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.262/aws-java-sdk-bundle-1.12.262.jar && \
    curl -L -o /opt/bitnami/spark/jars/hadoop-aws-3.3.4.jar \
    https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar

# Copy custom Spark applications
COPY apps/ /opt/bitnami/spark/apps/
COPY conf/ /opt/bitnami/spark/conf-custom/

# Set proper permissions
RUN chown -R spark:spark /opt/bitnami/spark/jars /opt/bitnami/spark/apps /opt/bitnami/spark/conf-custom

USER spark

# Environment variables for S3/MinIO
ENV AWS_ACCESS_KEY_ID=admin
ENV AWS_SECRET_ACCESS_KEY=password123
ENV S3_ENDPOINT=http://minio:9000
ENV S3_PATH_STYLE_ACCESS=true

# Spark configuration for Iceberg
ENV SPARK_CONF_spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions
ENV SPARK_CONF_spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog
ENV SPARK_CONF_spark.sql.catalog.spark_catalog.type=hive
ENV SPARK_CONF_spark.sql.catalog.local=org.apache.iceberg.spark.SparkCatalog
ENV SPARK_CONF_spark.sql.catalog.local.type=hadoop
ENV SPARK_CONF_spark.sql.catalog.local.warehouse=s3a://warehouse/
