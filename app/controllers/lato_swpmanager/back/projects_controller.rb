module LatoSwpmanager
  class Back::ProjectsController < Back::BackController

    before_action :check_user_is_admin, except: [:show]

    before_action do
      view_setCurrentVoice('swpmanager_projects')
    end

    def index
      # find correct projects for user
      if @superuser_is_superadmin
        @projects = Project.all.paginate(page: params[:page], per_page: 20).order('title ASC')
      else
        @projects = Project.where(superuser_manager_id: @superuser.id).paginate(page: params[:page], per_page: 20).order('title ASC')
      end
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
      # prepare datas for form
      if params[:task_id]
        @task = Task.find(params[:task_id])
      else
        @task = Task.new
      end
      @task_categories = TaskCategory.where(project_id: @project.id)
      # prepare datas for timeline
      if params[:init_date]
        @init_date = params[:init_date].to_date
        @end_date = @init_date + 6
      else
        @init_date = Date.yesterday
        @end_date = @init_date + 6
      end
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

    private def fetch_external_objects
      @clients = false
      @collaborators = Collaborator.all
      @superusers = LatoCore::Superuser.where('permission >= ?', swpmanager_getCollaboratorAdminSuperuserPermission)
    end

  end
end
