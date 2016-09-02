require '../lib/service_monitor'

def main
  services = ServiceMonitor::YamlLoader.build_services

  services.each { |service|
    service.determine_restart!
  }
end

main
