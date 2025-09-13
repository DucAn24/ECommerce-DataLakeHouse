# 🛠️ Configurations Directory

Thư mục này chứa tất cả các file cấu hình cho các services trong Data Lakehouse. Tất cả các cấu hình inline trong docker-compose.yml đã được tách ra thành các file riêng để dễ quản lý và customize.

## 📁 Cấu trúc

```
configs/
├── airflow/                     # Apache Airflow configurations
│   └── airflow.env             # Environment variables cho Airflow
├── flink/                       # Apache Flink configurations  
│   └── flink.properties        # Flink cluster configuration
├── spark/                       # Apache Spark configurations
│   └── spark-defaults.conf     # Spark default configurations with Iceberg
├── trino/                       # Trino query engine configurations
│   ├── config.properties       # Coordinator configuration
│   ├── node.properties         # Node configuration
│   ├── worker-config.properties # Worker configuration
│   ├── worker-node.properties  # Worker node properties
│   └── catalog/                # Data catalog configurations
│       ├── hive.properties     # Hive Metastore catalog
│       ├── delta.properties    # Delta Lake catalog
│       └── iceberg.properties  # Iceberg catalog
├── kafka-connect/               # Kafka Connect configurations
│   ├── worker.properties       # Connect worker configuration
│   ├── debezium-postgres.json  # Debezium CDC connector
│   └── init-connectors.sh      # Connector installation script
├── minio/                       # MinIO object storage configurations
│   └── setup-buckets.sh       # Bucket creation script
├── superset/                    # Apache Superset BI configurations
│   ├── init-superset.sh       # Superset initialization
│   ├── worker.sh              # Celery worker script
│   └── beat.sh                # Celery beat scheduler
├── filebeat/                    # Filebeat log collection
│   └── filebeat.yml           # Filebeat configuration
├── logstash/                    # Logstash log processing
│   ├── pipeline/
│   │   └── logstash.conf      # Processing pipeline
│   └── config/
│       └── logstash.yml       # Logstash configuration
├── prometheus/                  # Prometheus monitoring
│   └── prometheus.yml         # Monitoring targets
└── grafana/                     # Grafana dashboards (future)
```

## 🔧 Các loại Configuration

### 1. **Environment Files (.env)**
- **airflow/airflow.env**: Tất cả environment variables cho Airflow services
- Được load bằng `env_file` trong docker-compose.yml

### 2. **Properties Files (.properties, .conf)**
- **flink/flink.properties**: Flink cluster settings, checkpointing, memory
- **spark/spark-defaults.conf**: Spark với Iceberg và S3 configuration  
- **trino/**: Trino coordinator, worker, và catalog configurations
- **kafka-connect/worker.properties**: Kafka Connect worker settings

### 3. **Shell Scripts (.sh)**
- **minio/setup-buckets.sh**: Tạo và cấu hình buckets
- **superset/init-superset.sh**: Khởi tạo Superset với admin user
- **superset/worker.sh**: Celery worker cho async queries
- **superset/beat.sh**: Celery beat cho scheduled tasks
- **kafka-connect/init-connectors.sh**: Cài đặt và khởi động connectors

### 4. **YAML Configurations (.yml)**
- **filebeat/filebeat.yml**: Log collection và Kafka output
- **logstash/config/logstash.yml**: Logstash server configuration  
- **prometheus/prometheus.yml**: Monitoring targets và scraping

### 5. **JSON Configurations (.json)**
- **kafka-connect/debezium-postgres.json**: Debezium CDC connector definition

## 🚀 Cách sử dụng

### Customize Configurations

```bash
# Edit Flink settings
vi configs/flink/flink.properties

# Modify Spark configurations
vi configs/spark/spark-defaults.conf

# Update Trino catalogs
vi configs/trino/catalog/hive.properties

# Change Airflow settings
vi configs/airflow/airflow.env
```

### Test Configuration Changes

```bash
# Restart specific service after config change
docker-compose restart flink-jobmanager flink-taskmanager

# Reload Trino after catalog changes  
docker-compose restart trino-coordinator trino-worker

# Restart Spark after Iceberg config changes
docker-compose restart spark-master spark-worker
```

### Add New Configurations

1. **Create config file**: Add new `.properties`, `.conf`, hoặc `.sh` file
2. **Update docker-compose.yml**: Mount config file as volume
3. **Update service**: Use config file trong service startup

Example:
```yaml
services:
  my-service:
    volumes:
      - ./configs/my-service/config.conf:/etc/my-service/config.conf
```

## 📋 Configuration Details

### Airflow Environment
- **Database**: PostgreSQL connection với persistent storage
- **Executor**: CeleryExecutor with Redis broker  
- **Additional Providers**: Spark, Elasticsearch, Amazon S3
- **Security**: Basic authentication enabled

### Flink Properties
- **Checkpointing**: 60s intervals với filesystem backend
- **Memory**: JobManager 2GB, TaskManager 1.5GB
- **Parallelism**: Default 2, 4 slots per TaskManager
- **Kafka**: Bootstrap servers configured

### Spark Defaults
- **Iceberg**: SparkSessionExtensions enabled
- **Catalogs**: Hive Metastore và local Hadoop catalog
- **S3**: MinIO endpoint với credentials
- **Performance**: Adaptive query execution enabled

### Trino Catalogs
- **Hive**: Thrift metastore với S3 storage
- **Delta Lake**: Delta tables support
- **Iceberg**: Apache Iceberg tables
- **Security**: Read-only mode enabled [[memory:4765761]]

### Kafka Connect
- **Connectors**: Debezium PostgreSQL, S3 Sink, Elasticsearch
- **Converters**: JSON without schemas
- **Topics**: Auto-created với replication factor 1

## 🔍 Troubleshooting

### Configuration Not Loading
```bash
# Check file permissions
ls -la configs/service-name/

# Verify mount points
docker-compose config

# Check service logs
docker-compose logs service-name
```

### Invalid Configuration
```bash
# Validate YAML files
yamllint configs/prometheus/prometheus.yml

# Check properties syntax
grep -v "^#" configs/flink/flink.properties

# Test shell scripts
bash -n configs/minio/setup-buckets.sh
```

### Service Restart Issues
```bash
# Remove container và recreate
docker-compose rm service-name
docker-compose up -d service-name

# Check dependency issues
docker-compose ps
```

## 💡 Best Practices

1. **Version Control**: Luôn commit config changes
2. **Backup**: Backup configs trước khi thay đổi major
3. **Documentation**: Document custom configurations
4. **Testing**: Test trong dev environment trước production
5. **Security**: Không commit passwords/secrets vào git

## 🔗 Related Files

- `docker-compose.yml`: Main orchestration file
- `scripts/setup/`: Deployment scripts
- `sql/init/`: Database initialization  
- `airflow/dags/`: Workflow definitions

---

**Note**: Tất cả configurations được thiết kế cho development environment. Để production, cần review security settings và resource allocations.
