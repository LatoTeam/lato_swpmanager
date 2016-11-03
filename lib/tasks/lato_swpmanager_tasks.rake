include LatoSwpmanager

# Initialize module on project
desc 'Create swpmanager.yml file for Lato configuration'
task :lato_swpmanager_initialize do
  directory = core_getCacheDirectory
  FileUtils.cp "#{LatoSwpmanager::Engine.root}/config/example.yml", "#{Rails.root}/config/lato/swpmanager.yml"
end
