module ServiceMonitor
  class ServiceControl
    attr_accessor :service_name, :service_start, :service_stop, :service_status

    STATUSES = [
      STOPPED = 'STOPPED',
      RUNNING = 'RUNNING',
      DEAD = 'DEAD',
      FAILED = 'FAILED',
      OK = 'OK'
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

      match = status_out.match(/#{STOPPED}|#{DEAD}/i)

      if match
        puts "#{service_name} needs a RESTART"
        restart
      end

      puts "----------"
    end

    def status
      puts "Status for #{service_name} service"
      self.status_out = service_status.call
      puts status_out
      puts
    end

    def start
      puts "Starting #{service_name} service"
      self.start_out = service_start.call
      puts

      check_failure(start_out)
    end

    def stop
      puts "Stopping #{service_name} service"
      self.stop_out = service_stop.call
      puts

      check_failure(stop_out)
    end

    def restart
      stop
      start
    end


    private

    attr_accessor :status_out, :start_out, :stop_out

    def check_failure(output)
      match = output.match(/#{FAILED}/i)

      if match
        puts "There is an issue starting/stopping #{service_name}"
        puts "Please investigate"
        exit
      end
    end

  end
end
