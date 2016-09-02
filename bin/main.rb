require '../lib/service_monitor'

def main
  services = ServiceMonitor::YamlLoader.build_service_objects

  services.each { |service|
    service.determine_restart!
  }
end

main
