require '../lib/service_monitor'

def load_config
  YAML.load_file('../config/service_config.yaml')
end

def build_service_objects
  load_config.map { |config|
    ServiceMonitor::ServiceControl.build(config)
  }
end

def main
  service_list = build_service_objects

  service_list.each { |service|
    service.determine_restart!
  }
end

main
