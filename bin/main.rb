require '../lib/service_monitor'


def load_config
  YAML.load_file('../config/service_config.yaml')
end


def main
  service_list = load_config.map { |config|
    ServiceMonitor::ServiceControl.build(config)
  }

  service1 = service_list.first
  service1.status
  service1.restart
end

main
