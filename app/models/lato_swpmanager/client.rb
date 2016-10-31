module LatoSwpmanager
  class Client < ApplicationRecord

    has_many :projects, dependent: :nullify

  end
end
