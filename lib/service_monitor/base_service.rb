module ServiceMonitor
  class BaseService
    attr_accessor :cmd

    def initialize(cmd:)
      self.cmd = cmd
    end

    def call
      `#{cmd}`
    end

  end
end
