module LatoSwpmanager
  class TaskCategory < ApplicationRecord

    has_many :tasks, dependent: :destroy

    belongs_to :project

  end
end
