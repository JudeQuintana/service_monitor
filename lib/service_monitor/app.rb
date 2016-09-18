module ServiceMonitor
  class App < Sinatra::Base

    get '/' do
      @services = get_status_for_services

      erb :index
    end


    private

    def get_status_for_services
      services = YamlLoader.build_services

      services.map { |service|
        {
          :service_name   => service.service_name,
          :service_status => service.status
        }
      }
    end
  end
end
