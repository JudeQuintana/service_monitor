module ServiceMonitor
  class ServiceStart
    attr_accessor :start_cmd

    def initialize(start_cmd:)
      self.start_cmd = start_cmd
    end

    def call
      puts "Starting Service"
      puts "CMD: #{start_cmd}"
      puts
    end
  end
end
