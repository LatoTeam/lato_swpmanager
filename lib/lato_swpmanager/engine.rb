module LatoSwpmanager
  class Engine < ::Rails::Engine
    isolate_namespace LatoSwpmanager

    # Add migration support
    initializer 'Add migration support' do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end

    # Add routes support
    initializer 'Add gem routes to application',
                before: :load_config_initializers do
      Rails.application.routes.append do
        # change "/lato/swpmanager" with the lato module base url
        mount LatoSwpmanager::Engine, at: '/lato/swpmanager'
      end
    end

    # Add interface to main application
    config.autoload_paths << LatoSwpmanager::Engine.root.join('lib/interface')

  end
end
