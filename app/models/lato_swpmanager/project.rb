module LatoSwpmanager
  class Project < ApplicationRecord

    attr_accessor :collaborators_id

    belongs_to :client

    has_many :tasks, dependent: :destroy

    has_many :project_collaborators, dependent: :destroy
    has_many :collaborators, through: :project_collaborators

    before_update do
      update_collaborators_on_project
    end

    after_create do
      create_collaborators_on_project
    end

    # This function return the deadline with correct format.
    def string_deadline
      return self.deadline.strftime('%d/%m/%Y') if self.deadline
    end

    # This function return the name of the superuser creator of the project.
    def string_superuser_creator_name
      superuser = LatoCore::Superuser.find_by(id: self.superuser_creator_id)
      return superuser.name if superuser
    end

    # This function return the name of the superuser manager of the project.
    def string_superuser_manager_name
      superuser = LatoCore::Superuser.find_by(id: self.superuser_manager_id)
      return superuser.name if superuser
    end

    # This function return a string with all names of collaborators of project.
    def string_collaborators
      names = []
      self.collaborators.each do |collaborator|
        names.push collaborator.string_complete_name
      end
      return names.join(", ")
    end

    # This function return the list of ids of collaborators of the project.
    def get_collaborators_id
      return ProjectCollaborator.where(project_id: self.id).pluck(:collaborator_id)
    end

    # This function return all the collaborators of the project.
    def get_collaborators
      return Collaborator.where(id: self.get_collaborators_id)
    end

    # This function return all tasks that collaborator must see on on its profile.
    def get_collaborator_tasks(collaborator_id)
      return self.tasks.where(collaborator_id: collaborator_id, status: ['wait', 'develop']).order('end_date ASC')
    end

    # This function create or update collaborators on project.
    private def update_collaborators_on_project
      if self.collaborators_id
        actual = ProjectCollaborator.where(project_id: self.id)
        # destroy old relations
        actual.each do |single_actual|
          unless self.collaborators_id.include? single_actual.id
            single_actual.destroy
          end
        end
        # create new relations
        actual_ids = actual.pluck(:id)
        self.collaborators_id.each do |new_id|
          unless actual_ids.include? new_id
            ProjectCollaborator.create(project_id: self.id, collaborator_id: new_id)
          end
        end
      end
    end

    # This function create collaborators on project.
    private def create_collaborators_on_project
      if self.collaborators_id
        self.collaborators_id.each do |new_id|
          ProjectCollaborator.create(project_id: self.id, collaborator_id: new_id)
        end
      end
    end

  end
end
