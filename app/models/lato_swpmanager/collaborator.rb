module LatoSwpmanager
  class Collaborator < ApplicationRecord

    attr_accessor :superuser, :superuser_admin

    validates :surname, uniqueness: true
    validates :email, uniqueness: true

    has_many :tasks, dependent: :nullify

    has_many :project_collaborators, dependent: :destroy
    has_many :projects, through: :project_collaborators

    before_create do
      check_superuser_request
    end

    before_update do
      check_superuser_request
    end

    before_destroy do
      destroy_superuser
    end

    # This function return the complete name of collaborator.
    def string_complete_name
      return "#{self.surname} #{self.name}"
    end

    # This function check if superuser is requested and create it.
    private def check_superuser_request
      if self.superuser && (self.superuser == '1' || self.superuser == true)
        if self.superuser_id
          superuser = LatoCore::Superuser.find_by(id: self.superuser_id)
          create_superuser unless superuser
        else
          create_superuser
        end
      end
    end

    # This function create a new superuser with collaborator data.
    private def create_superuser
      permission = swpmanager_getCollaboratorSuperuserPermission
      if self.superuser_admin && (self.superuser_admin == '1' || self.superuser_admin == true)
        permission = swpmanager_getCollaboratorAdminSuperuserPermission
      end
      superuser = LatoCore::Superuser.new(email: self.email, name: self.string_complete_name,
      username: self.string_complete_name.parameterize, password: 'password',
      password_confirmation: 'password', permission: permission)
      unless superuser.save
        errors.add('Access user', 'for this email already exist')
        throw :abort
      else
        self.superuser_id = superuser.id
      end
    end

    # This function destroy the superuser of the collaborator.
    private def destroy_superuser
      if self.superuser_id
        superuser = LatoCore::Superuser.find_by(id: self.superuser_id)
        superuser.destroy if superuser
      end
    end

  end
end
