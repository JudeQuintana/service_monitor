require '../lib/service_monitor'

def main
  service_list = ServiceMonitor::YamlLoader.build_service_objects

  service_list.each { |service|
    service.determine_restart!
  }
end

main
