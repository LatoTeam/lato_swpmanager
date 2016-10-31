module LatoSwpmanager
  class TaskMessage < ApplicationRecord

    belongs_to :task

    # This function return the name of the superuser of the message.
    def get_superuser_name
      superuser = LatoCore::Superuser.find_by(id: self.superuser_creator_id)
      return superuser.name if superuser
    end

  end
end
