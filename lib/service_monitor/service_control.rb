module ServiceMonitor
  class ServiceControl
    attr_accessor :service_name, :service_start, :service_stop, :service_status

    STATUSES = [
      OKAY    = 'OK',
      RUNNING = 'RUNNING',
      STOPPED = 'STOPPED',
      DEAD    = 'DEAD',
      FAILED  = 'FAILED'
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
      puts Time.now.to_s + "\n\n"

      status_output = status

      check_restart(status_output)

      puts "\n----------"
    end

    def status
      puts "[+] Status for #{service_name} service\n"

      status_output = service_status.call

      puts "[+] " + status_output + "\n"

      status_output
    end

    def start
      puts "[+] Starting #{service_name} service\n"

      start_output = service_start.call

      check_failure(start_output)
    end

    def stop
      puts "[+] Stopping #{service_name} service\n"

      stop_output = service_stop.call

      check_failure(stop_output)
    end

    def restart
      stop
      start
    end


    private

    def check_restart(output)
      match = output.match(/#{STOPPED}|#{DEAD}/i)

      if match
        puts "[+] #{service_name} needs a RESTART\n"
        restart
      end
    end

    def check_failure(output)
      match = output.match(/#{FAILED}/i)

      if match
        puts "\n[+] There is an issue starting/stopping #{service_name}\nPlease investigate!"
        exit
      end
    end

  end
end
