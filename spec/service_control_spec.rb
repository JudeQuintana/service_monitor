require 'spec_helper'

module ServiceMonitor
  RSpec.describe ServiceControl do
    it "calls each of the underlying service objects for each public method" do

      config = {
        'service_name' => 'apache'
      }

      service_status = service_status_double
      allow(service_status).to receive(:call).and_return("httpd is stopped")

      service_start = service_start_double
      allow(service_start).to receive(:call).and_return("Starting httpd: [  OK  ]")

      service_stop = service_stop_double
      allow(service_stop).to receive(:call).and_return("Stopping httpd: [  OK  ]")

      service_control = ServiceControl.new(:service_name   => config.fetch('service_name'),
                                           :service_start  => service_start,
                                           :service_stop   => service_stop,
                                           :service_status => service_status
      )

      expect(service_control.service_name).to eq("apache")

      service_control.start

      expect(service_start).to have_received(:call)

      service_control.stop

      expect(service_stop).to have_received(:call)

      service_control.status

      expect(service_status).to have_received(:call)

      #resetting mock objects
      RSpec::Mocks.space.proxy_for(service_start).reset
      RSpec::Mocks.space.proxy_for(service_stop).reset

      allow(service_start).to receive(:call).and_return("Starting httpd: [  OK  ]")
      allow(service_stop).to receive(:call).and_return("Stopping httpd: [  OK  ]")

      service_control.restart

      expect(service_start).to have_received(:call)
      expect(service_stop).to have_received(:call)

      #resetting mock objects
      RSpec::Mocks.space.proxy_for(service_status).reset
      RSpec::Mocks.space.proxy_for(service_start).reset

      #this will start the service due to stopped service
      allow(service_status).to receive(:call).and_return("httpd is stopped")
      allow(service_start).to receive(:call).and_return("Starting httpd: [  OK  ]")

      service_control.determine_restart!

      expect(service_status).to have_received(:call)
      expect(service_start).to have_received(:call)

      #resetting mock objects
      RSpec::Mocks.space.proxy_for(service_status).reset
      RSpec::Mocks.space.proxy_for(service_start).reset

      #this will start the service due to dead service
      allow(service_status).to receive(:call).and_return("httpd dead but subsys locked")
      allow(service_start).to receive(:call).and_return("Starting httpd: [  OK  ]")

      service_control.determine_restart!

      expect(service_status).to have_received(:call)
      expect(service_start).to have_received(:call)

      #resetting mock objects
      RSpec::Mocks.space.proxy_for(service_status).reset
      RSpec::Mocks.space.proxy_for(service_start).reset

      #this will wont start the service if already running
      allow(service_status).to receive(:call).and_return("httpd is running")
      allow(service_start).to receive(:call).and_return("Starting httpd: [  OK  ]")

      service_control.determine_restart!

      expect(service_status).to have_received(:call)
      expect(service_start).to_not have_received(:call)
    end

    def service_status_double
      double
    end

    def service_start_double
      double
    end

    def service_stop_double
      double
    end

  end
end
