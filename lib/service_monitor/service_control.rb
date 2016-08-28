module ServiceMonitor
  class ServiceControl
    attr_accessor :service_name, :service_start, :service_stop, :service_status

    STATUSES = [
      STOPPED = 'STOPPED',
      RUNNING = 'RUNNING',
      DEAD = 'DEAD'
    ]

    def self.build(config)
      new(:service_name   => config.fetch('service_name'),
          :service_start  => ServiceStart.new(:cmd => config.fetch('start_cmd')),
          :service_stop   => ServiceStop.new(:cmd => config.fetch('stop_cmd')),
          :service_status => ServiceStatus.new(:cmd => config.fetch('status_cmd'))
      )
    end

    def initialize(service_name:, service_start:, service_stop:, service_status:)
      self.service_name   = service_name
      self.service_start  = service_start
      self.service_stop   = service_stop
      self.service_status = service_status
    end

    def determine_restart!
      status

      match = output.match(/#{STOPPED}|#{DEAD}/i)

      if match
        puts "#{service_name} needs a RESTART"
        restart
      end

      puts "----------"
    end

    def status
      puts "Status for #{service_name} service"
      self.output = service_status.call
      puts output
      puts
    end

    def start
      puts "Starting #{service_name} service"
      service_start.call
      puts
    end

    def stop
      puts "Stopping #{service_name} service"
      service_stop.call
      puts
    end

    def restart
      stop
      start
    end


    private

    attr_accessor :output
  end
end
