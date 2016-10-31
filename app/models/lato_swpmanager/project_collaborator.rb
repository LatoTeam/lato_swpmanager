module LatoSwpmanager
  class ProjectCollaborator < ApplicationRecord

    validates :collaborator_id, uniqueness: {scope: :project_id}

    belongs_to :collaborator
    belongs_to :project

  end
end
