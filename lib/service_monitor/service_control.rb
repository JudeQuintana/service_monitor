module ServiceMonitor
  class ServiceControl
    attr_accessor :service_name, :service_start, :service_stop, :service_status

    def self.build(config)
      new(:service_name   => config.fetch('service_name'),
          :service_start  => ServiceStart.new(:start_cmd => config.fetch('start_cmd')),
          :service_stop   => ServiceStop.new(:stop_cmd => config.fetch('stop_cmd')),
          :service_status => ServiceStatus.new(:status_cmd => config.fetch('status_cmd'))
      )
    end

    def initialize(service_name:, service_start:, service_stop:, service_status:)
      self.service_name   = service_name
      self.service_start  = service_start
      self.service_stop   = service_stop
      self.service_status = service_status
    end

    def status
      puts "Status for #{service_name} service"
      service_status.call
    end

    def start
      puts "Starting #{service_name} service"
      service_start.call
    end

    def stop
      puts "Stopping #{service_name} service"
      service_stop.call
    end

    def restart
      stop
      start
    end
  end
end
