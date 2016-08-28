module ServiceMonitor
  class ServiceStop
    attr_accessor :stop_cmd

    def initialize(stop_cmd:)
      self.stop_cmd = stop_cmd
    end

    def call
      puts "Stop Service"
      puts "CMD: #{stop_cmd}"
      puts
    end
  end
end
