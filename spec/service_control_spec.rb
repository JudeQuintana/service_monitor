require 'spec_helper'

module ServiceMonitor
  RSpec.describe ServiceControl do

    describe ".start" do
      it "only calls the service_start object" do
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

        service_control.start

        expect(service_start).to have_received(:call)

        expect(service_status).to_not have_received(:call)
        expect(service_stop).to_not have_received(:call)
      end
    end

    describe ".stop" do
      it "only calls the service_stop object" do
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

        service_control.stop

        expect(service_stop).to have_received(:call)

        expect(service_status).to_not have_received(:call)
        expect(service_start).to_not have_received(:call)
      end
    end

    describe ".status" do
      it "only calls the service_status object" do
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

        service_control.status

        expect(service_status).to have_received(:call)

        expect(service_start).to_not have_received(:call)
        expect(service_stop).to_not have_received(:call)
      end
    end

    describe ".restart" do
      it "only calls both service_start and service_stop object" do
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

        service_control.restart

        expect(service_start).to have_received(:call)
        expect(service_stop).to have_received(:call)

        expect(service_status).to_not have_received(:call)
      end

    end

    describe ".determine_restart!" do
      context "when service_status is running" do
        it "will NOT restart the service" do
          config = {
            'service_name' => 'apache'
          }

          service_status = service_status_double
          allow(service_status).to receive(:call).and_return("httpd is running")

          service_start = service_start_double
          allow(service_start).to receive(:call).and_return("Starting httpd: [  OK  ]")

          service_stop = service_stop_double
          allow(service_stop).to receive(:call).and_return("Stopping httpd: [  OK  ]")

          service_control = ServiceControl.new(:service_name   => config.fetch('service_name'),
                                               :service_start  => service_start,
                                               :service_stop   => service_stop,
                                               :service_status => service_status
          )

          service_control.determine_restart!

          expect(service_status).to have_received(:call)
          expect(service_start).to_not have_received(:call)
          expect(service_stop).to_not have_received(:call)
        end
      end

      context "when service_status is stopped" do
        it "will restart the service" do
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

          service_control.determine_restart!

          expect(service_status).to have_received(:call)
          expect(service_start).to have_received(:call)
          expect(service_stop).to have_received(:call)
        end
      end

      context "when service_status is dead" do
        it "will restart the service" do
          config = {
            'service_name' => 'apache'
          }

          service_status = service_status_double
          allow(service_status).to receive(:call).and_return("httpd is dead")

          service_start = service_start_double
          allow(service_start).to receive(:call).and_return("Starting httpd: [  OK  ]")

          service_stop = service_stop_double
          allow(service_stop).to receive(:call).and_return("Stopping httpd: [  OK  ]")

          service_control = ServiceControl.new(:service_name   => config.fetch('service_name'),
                                               :service_start  => service_start,
                                               :service_stop   => service_stop,
                                               :service_status => service_status
          )

          service_control.determine_restart!

          expect(service_status).to have_received(:call)
          expect(service_start).to have_received(:call)
          expect(service_stop).to have_received(:call)
        end
      end
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
