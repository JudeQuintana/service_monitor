require '../lib/service_monitor'

def load_config
  YAML.load_file('../config/service_config.yaml')
end

def main
  service_list = load_config.map { |config|
    ServiceMonitor::ServiceControl.build(config)
  }

  service_list.each { |service|
    service.determine_restart!
  }
end

main
