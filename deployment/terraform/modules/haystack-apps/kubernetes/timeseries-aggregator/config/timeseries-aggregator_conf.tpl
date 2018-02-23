health.status.path = "/app/isHealthy"

kafka {
  close.timeout.ms = 30000

  streams {
    application.id = "haystack-timeseries-aggregator"
    bootstrap.servers = "${kafka_endpoint}"
    num.stream.threads = 1
    commit.interval.ms = 3000
    auto.offset.reset = latest
    timestamp.extractor = "com.expedia.www.haystack.trends.kstream.MetricPointTimestampExtractor"
  }

  // For producing data to external kafka: set enable.external.kafka.produce to true and uncomment the props.
  // For producing to same kafka: set enable.external.kafka.produce to false and comment the props.
  producer {
    topic = "mdm"
    enable.external.kafka.produce = ${enable_external_kafka_producer}
     props {
       bootstrap.servers = "${external_kafka_producer_endpoint}"
     }
  }

  consumer {
    topic = "metricpoints"
  }
}

state.store {
  cleanup.policy = "compact,delete"
  retention.ms = 14400000 // 4Hrs
}

statestore {
  enable.logging = true
  logging.delay.seconds = 60
}

health.status.path = "./isHealthy"

haystack.graphite.host = "monitoring-influxdb-graphite.kube-system.svc"

enable.metricpoint.period.replacement = true