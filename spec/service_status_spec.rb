require 'spec_helper'

module ServiceMonitor
  RSpec.describe ServiceControl do
    it "calls each of the service commands" do

      config = {
        'service_name' => 'ssh',
        'start_cmd'    => 'service start ssh',
        'stop_cmd'     => 'service start ssh',
        'status_cmd'   => 'service ssh status'
      }


    end

    def service_status_double
      double(:call => true)
    end

    def service_start_double
      double(:call => true)
    end

    def service_stop_double
      double(:call => true)
    end

  end
end