module ServiceMonitor
  class BaseService
    attr_accessor :cmd

    def initialize(cmd:)
      self.cmd = cmd
    end

    def call
      begin
        output = `#{cmd}`
      rescue Exception => e
        output = e.message
        puts "[+] There was a problem running the #{cmd} command!\n[+] Please fix it!\n#{output}"
        exit
      end

      output
    end

  end
end
