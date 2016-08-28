module ServiceMonitor
  class BaseService
    attr_accessor :cmd

    def initialize(cmd:)
      self.cmd = cmd
    end

    def call
      # puts "CMD: #{cmd}"
      #
      # "service is running!"
      # "service is stopped!"
      # "dead but subsys locked"
      `#{cmd}`
    end

  end
end
