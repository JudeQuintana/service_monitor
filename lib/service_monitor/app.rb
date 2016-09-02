module ServiceMonitor
  class App < Sinatra::Base

    get '/' do
      @services = get_status_for_services

      erb :index
    end


    private

    def get_status_for_services
      service_list = YamlLoader.build_services

      service_list.map { |service|
        {
          :service_name   => service.service_name,
          :service_status => service.status
        }
      }
    end
  end
end
