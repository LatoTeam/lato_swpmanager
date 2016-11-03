module LatoSwpmanager
  # This is an example module.
  module Interface::Collaborators

      # This function read the configuration file and return the default
      # collaborators superuser permission level.
      def swpmanager_getCollaboratorSuperuserPermission
        return SWPMANAGER_COLLABORATORSUPERUSERPERMISSION if defined? SWPMANAGER_COLLABORATORSUPERUSERPERMISSION
        permission = 1
        if File.exist? "#{Rails.root}/config/lato/swpmanager.yml"
          config = YAML.load(
            File.read(File.expand_path("#{Rails.root}/config/lato/swpmanager.yml", __FILE__))
          )
          if config && config['collaborator_superuser_permission']
            permission = config['collaborator_superuser_permission']
          end
        end
        # return result
        return permission
      end

      # This function read the configuration file and return the default
      # collaborators admin superuser permission level.
      def swpmanager_getCollaboratorAdminSuperuserPermission
        return SWPMANAGER_COLLABORATORADMINSUPERUSERPERMISSION if defined? SWPMANAGER_COLLABORATORADMINSUPERUSERPERMISSION
        permission = 2
        if File.exist? "#{Rails.root}/config/lato/swpmanager.yml"
          config = YAML.load(
            File.read(File.expand_path("#{Rails.root}/config/lato/swpmanager.yml", __FILE__))
          )
          if config['collaborator_admin_superuser_permission']
            permission = config['collaborator_admin_superuser_permission']
          end
        end
        # return result
        return permission
      end

  end
end
