module LatoSwpmanager
  # This module contains some functions used to work with clients external models.
  module Interface::Clients

    # This function read the configuration file and return the default
    # clients model name.
    def swpmanager_getClientModelName
      return SWPMANAGER_CLIENTMODELNAME if defined? SWPMANAGER_CLIENTMODELNAME
      model_name = false
      if File.exist? "#{Rails.root}/config/lato/swpmanager.yml"
        config = YAML.load(
          File.read(File.expand_path("#{Rails.root}/config/lato/swpmanager.yml", __FILE__))
        )
        if config && config['client_model_name']
          model_name = config['client_model_name']
        end
      end
      # return result
      return model_name
    end

    # This function read the configuration file and return the default
    # clients function used to get the name of client.
    def swpmanager_getClientGetNameFunction
      return SWPMANAGER_CLIENTGETNAMEFUNCTION if defined? SWPMANAGER_CLIENTGETNAMEFUNCTION
      model_function_name = false
      if File.exist? "#{Rails.root}/config/lato/swpmanager.yml"
        config = YAML.load(
          File.read(File.expand_path("#{Rails.root}/config/lato/swpmanager.yml", __FILE__))
        )
        if config && config['client_get_name_function']
          model_function_name = config['client_get_name_function']
        end
      end
      # return result
      return model_function_name
    end

  end
end
