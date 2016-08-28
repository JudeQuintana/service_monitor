module ServiceMonitor
  class ServiceStatus
    attr_accessor :status_cmd

    def initialize(status_cmd:)
      self.status_cmd = status_cmd
    end

    def call
      puts "CMD: #{status_cmd}"
      puts
    end
  end
end