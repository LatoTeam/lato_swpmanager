module LatoSwpmanager
  class Back::BackController < ApplicationController

    include LatoCore::Interface
    include LatoView::Interface
    include LatoSwpmanager::Interface

    # set lato view layout
    layout 'lato_layout'

    # check user is logged
    before_action :core_controlUser

    before_action :set_superuser_data

    private def set_superuser_data
      @superuser = core_getCurrentUser
      @superuser_admin = core_controlPermission(2)
      @superuser_collaborator = Collaborator.find_by(superuser_id: @superuser.id)
    end

    # Home profile page
    def profile
      if @superuser_collaborator
        redirect_to lato_swpmanager.collaborator_path(@superuser_collaborator.id)
      elsif @superuser_admin
        redirect_to lato_swpmanager.projects_path
      else
        core_destroySession
        redirect_to lato_core.root_path
      end
    end

    # Params functions ###

    protected def project_params
      params.require(:project).permit(:title, :deadline, :quote, :client_id,
      :description, :status, :staging_url, :production_url,
      :ftp_server, :ftp_user, :ftp_password, :ssh_server, :ssh_user, :ssh_password,
      :main_domain, :hosting_provider, collaborators_id: [])
    end

    protected def client_params
      params.require(:client).permit(:name, :email, :phone, :website)
    end

    protected def collaborator_params
      params.require(:collaborator).permit(:name, :surname, :email, :phone, :superuser,
      :superuser_admin)
    end

    protected def task_params
      params.require(:task).permit(:title, :description, :collaborator_id, :project_id,
      :start_date, :end_date, :budget, :expected_work_time, :real_work_time, :status)
    end

    protected def task_message_params
      params.require(:task_message).permit(:message, :task_id)
    end

  end
end
