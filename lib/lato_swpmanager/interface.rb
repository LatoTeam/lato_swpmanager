module LatoSwpmanager
  module Interface

    require 'lato_swpmanager/interface/collaborators'
    include LatoSwpmanager::Interface::Collaborators

    require 'lato_swpmanager/interface/clients'
    include LatoSwpmanager::Interface::Clients

  end
end
