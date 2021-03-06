
module LatoSwpmanager
  class Back::ProjectsController < Back::BackController

    before_action :check_user_is_admin, except: [:show]

    def index
      @search_projects = Project.ransack(params[:q])
      # find correct projects for user
      if @superuser_is_superadmin
        @projects = @search_projects.result.paginate(page: params[:page], per_page: 20).order('title ASC')
      else
        @projects = @search_projects.result.where(superuser_manager_id: @superuser.id).paginate(page: params[:page], per_page: 20).order('title ASC')
      end
      # find correct develop projects
      @projects_develop = @projects.where(status: 'develop')
    end

    def new
      # generate new project
      @project = Project.new
      fetch_external_objects
    end

    def create
      # generate project
      project = Project.new(project_params)
      # save superuser creator
      project.superuser_creator_id = @superuser.id
      #  save project
      if project.save
        flash[:success] = "Project created"
        redirect_to lato_swpmanager.project_path(project.id)
      else
        flash[:danger] = "Project not created"
        redirect_to lato_swpmanager.projects_path
      end
    end

    def edit
      # find project
      @project = Project.find(params[:id])
      # check user is manager of project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? @project))
        flash[:warning] = "You can't edit this project"
        redirect_to lato_core.root_path and return false
      end
      # fetch external object
      fetch_external_objects
    end

    def update
      # find project
      project = Project.find(params[:id])
      # check user is manager of project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? project))
        flash[:warning] = "You can't edit this project"
        redirect_to lato_core.root_path and return false
      end
      # exec update
      if project.update(project_params)
        flash[:success] = "Project updated"
      else
        flash[:danger] = "Project not updated"
      end

      redirect_to lato_swpmanager.project_path
    end

    def destroy
      # find project
      project = Project.find(params[:id])
      # check user is manager of project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? project))
        flash[:warning] = "You can't destroy this project"
        redirect_to lato_core.root_path and return false
      end
      # destroy project
      project.destroy
      # return result
      flash[:success] = "Project deleted"
      redirect_to lato_swpmanager.projects_path
    end

    def show
      @project = Project.find(params[:id])
      @tasks = @project.tasks

      # check user is collaborator of project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? @project))
        flash[:warning] = "You can't get information about this project"
        redirect_to lato_core.root_path and return false
      end

      # find client datas
      @client = false
      @client_function = false

      clients_model_name = swpmanager_getClientModelName
      clients_get_name_function = swpmanager_getClientGetNameFunction
      if clients_model_name && clients_get_name_function
        @client = clients_model_name.constantize.find_by(id: @project.client_id)
        @client_function = clients_get_name_function
      end
    end

    # This action show all tasks of project.
    def tasks
      # find project
      @project = Project.find(params[:id])
      # check user is manager of project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? @project))
        flash[:warning] = "You can't see tasks for this project"
        redirect_to lato_core.root_path and return false
      end
      # find datas
      @tasks = Task.where(project_id: @project.id).order('end_date ASC')
      @deadline_tasks = @tasks.where('end_date <= ?', Date.today + 1).where.not(status: 'completed')
      @wait_tasks = @tasks.where(status: 'wait')
      @develop_tasks = @tasks.where(status: 'develop')
      @test_tasks = @tasks.where(status: 'test')
      @completed_tasks = @tasks.where(status: 'completed')
      # prepare datas for timeline
      if params[:init_date]
        @init_date = params[:init_date].to_date
        @end_date = @init_date + 6
        # update page without refresh
        respond_to do |format|
          format.js { render action: 'functions/update_timeline'}
        end
      else
        @init_date = Date.yesterday
        @end_date = @init_date + 6
      end
    end

    # This action update all old develop/wait tasks start date.
    def update_late_tasks
      # find project
      project = Project.find(params[:id])
      # check user is manager of project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? project))
        flash[:warning] = "You can't do this action for this project"
        redirect_to lato_core.root_path and return false
      end
      # find tasks
      today = Date.today
      tasks = project.tasks.where(status: ['wait', 'develop']).where('end_date < ?', today)
      # update tasks
      tasks.each do |task|
        days_long = task.end_date - task.start_date
        task.update(start_date: today, end_date: today + days_long)
      end
      # return result
      flash[:success] = 'Operation done'
      redirect_to lato_swpmanager.project_tasks_path(id: project.id)
    end

    # This function render a request about settings for the print tasks
    # configurations.
    def settings_print_tasks
      # find project
      @project = Project.find(params[:id])
      # check user is manager of project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? @project))
        flash[:warning] = "You can't see stats for this project"
        redirect_to lato_core.root_path and return false
      end
      # get all collaborators
      @collaborators = @project.collaborators
    end

    # This function render a print version of tasks for a single project.
    def print_tasks
      # find project
      @project = Project.find(params[:id])
      # check user is manager of project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? @project))
        flash[:warning] = "You can't see stats for this project"
        redirect_to lato_core.root_path and return false
      end
      # datas
      @status = (params[:status] ? params[:status] : ['wait', 'develop', 'test', 'completed'])
      @collaborators = (params[:collaborators] ? params[:collaborators] : @project.collaborators.ids)
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @show_expected_time = (params[:show_expected_time] === '1')
      # find tasks
      @tasks = @project.tasks.where(status: @status, collaborator_id: @collaborators)
      unless @start_date.blank?
        @tasks = @tasks.where('start_date >= ?', @start_date.to_date)
      end
      unless @end_date.blank?
        @tasks = @tasks.where('end_date <= ?', @end_date.to_date)
      end
      # disable layout
      render layout: false
    end

    # This action show stats informations of project.
    def stats
      # find project
      @project = Project.find(params[:id])
      # check user is manager of project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? @project))
        flash[:warning] = "You can't see stats for this project"
        redirect_to lato_core.root_path and return false
      end
      # find datas
      @tasks = Task.where(project_id: @project.id).order('end_date ASC')
      @wait_tasks = @tasks.where(status: 'wait')
      @develop_tasks = @tasks.where(status: 'develop')
      @test_tasks = @tasks.where(status: 'test')
      @completed_tasks = @tasks.where(status: 'completed')
      @collaborators = @project.collaborators
    end

    private def fetch_external_objects
      @collaborators = Collaborator.all
      @superusers = LatoCore::Superuser.where('permission >= ?', swpmanager_getCollaboratorAdminSuperuserPermission)

      @clients = false
      @clients_function = false

      clients_model_name = swpmanager_getClientModelName
      clients_get_name_function = swpmanager_getClientGetNameFunction
      if clients_model_name && clients_get_name_function
        @clients = clients_model_name.constantize.all
        @clients_function = clients_get_name_function
      end
    end

  end
end
