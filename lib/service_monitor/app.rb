module ServiceMonitor
  class App < Sinatra::Base
    set :service_config, YAML.load_file(File.expand_path('../../../config/service_config.yaml', __FILE__))

    get '/' do
      @services = get_status_for_services

      erb :index
    end


    private

    def build_service_objects
      settings.service_config.map { |config|
        ServiceMonitor::ServiceControl.build(config)
      }
    end

    def get_status_for_services
      service_list = build_service_objects

      service_list.map { |service|
        {
          :service_name   => service.service_name,
          :service_status => service.status,
        }
      }
    end
  end
end
