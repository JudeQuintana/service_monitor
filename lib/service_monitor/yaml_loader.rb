module ServiceMonitor
  class YamlLoader

    def self.load_config
      YAML.load_file(File.expand_path('../../../config/service_config.yaml', __FILE__))
    end

    def self.build_services
      load_config.map { |config|
        ServiceControl.build(config)
      }
    end

  end
end
