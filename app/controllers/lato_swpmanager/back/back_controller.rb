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
      @superuser_collaborator = Collaborator.find_by(superuser_id: @superuser.id)
      @superuser_is_admin = core_controlPermission(swpmanager_getCollaboratorAdminSuperuserPermission)
      @superuser_is_superadmin = core_controlPermission(6)
    end

    protected def check_user_is_admin
      unless @superuser_is_admin
        flash[:warning] = "You don't have permission to do this action"
        redirect_to lato_core.root_path
        return false
      end
    end

    protected def check_user_is_superadmin
      unless @superuser_is_superadmin
        flash[:warning] = "You don't have permission to do this action"
        redirect_to lato_core.root_path
        return false
      end
    end

    # This function tells if current superuser is a member of the project (project
    # manager or team member).
    protected def superuser_is_part_of_project? project
      return true if @superuser_is_superadmin
      return (@superuser_collaborator.projects.include? project) || (project.superuser_manager_id === @superuser.id)
    end

    # Home profile page
    def profile
      if @superuser_collaborator
        redirect_to lato_swpmanager.collaborator_path(@superuser_collaborator.id)
      elsif @superuser_is_admin
        redirect_to lato_swpmanager.projects_path
      else
        core_destroySession
        redirect_to lato_core.root_path
      end
    end

    # Params functions

    protected def project_params
      params.require(:project).permit(:title, :deadline, :quote, :client_id,
      :description, :status, :staging_url, :production_url,
      :ftp_server, :ftp_user, :ftp_password, :ssh_server, :ssh_user, :ssh_password,
      :main_domain, :hosting_provider, :superuser_manager_id, collaborators_id: [])
    end

    protected def client_params
      params.require(:client).permit(:name, :email, :phone, :website)
    end

    protected def collaborator_params
      params.require(:collaborator).permit(:name, :surname, :email, :phone, :superuser,
      :superuser_admin, :work_time_per_day, :work_days_per_week)
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
