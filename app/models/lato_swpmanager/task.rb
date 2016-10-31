module LatoSwpmanager
  class Task < ApplicationRecord

    belongs_to :collaborator

    belongs_to :project

    has_many :task_messages, dependent: :destroy

    # This function return a string with the correct start date.
    def string_start_date
      return self.start_date.strftime('%d/%m/%Y') if self.start_date
    end

    # This function return a string with the correct end date.
    def string_end_date
      return self.end_date.strftime('%d/%m/%Y') if self.end_date
    end

    # This function return the collaborator complete name.
    def string_collaborator_complete_name
      return self.collaborator.string_complete_name if self.collaborator
    end

    # This function return the name of the superuser creator of the task.
    def string_superuser_creator_name
      superuser = LatoCore::Superuser.find_by(id: self.superuser_creator_id)
      return superuser.name if superuser
    end

    # This function return the title of the project.
    def string_project_title
      return self.project.title if self.project
    end

    # This function return the number of messages of the task.
    def get_messages_number
      return self.task_messages.length
    end

  end
end
