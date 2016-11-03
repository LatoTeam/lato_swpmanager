module LatoSwpmanager
  class Back::ProjectsController < Back::BackController

    before_action do
      view_setCurrentVoice('swpmanager_projects')
    end

    def index
      # check user is admin
      redirect_to lato_core.root_path and return false unless @superuser_admin
      # find correct projects for user
      if @superuser_superadmin
        @projects = Project.all.paginate(page: params[:page], per_page: 20).order('title ASC')
      else
        @projects = Project.where(superuser_creator_id: @superuser.id).paginate(page: params[:page], per_page: 20).order('title ASC')
      end
    end

    def new
      # check user is admin
      redirect_to lato_core.root_path and return false unless @superuser_admin
      # generate new project
      @project = Project.new
      fetch_external_objects
    end

    def create
      # check user is admin
      redirect_to lato_core.root_path and return false unless @superuser_admin
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

    def show
      @project = Project.find(params[:id])
      @tasks = @project.tasks

      if !@superuser_admin && !(@superuser_collaborator.projects.include? @project)
        redirect_to lato_core.root_path and return false
      end
    end

    def edit
      redirect_to lato_core.root_path and return false unless @superuser_admin

      @project = Project.find(params[:id])
      fetch_external_objects
    end

    def update
      redirect_to lato_core.root_path and return false unless @superuser_admin

      project = Project.find(params[:id])

      if project.update(project_params)
        flash[:success] = "Project updated"
      else
        flash[:danger] = "Project not updated"
      end

      redirect_to lato_swpmanager.project_path
    end

    def destroy
      redirect_to lato_core.root_path and return false unless @superuser_admin

      project = Project.find(params[:id])

      project.destroy

      flash[:success] = "Project deleted"
      redirect_to lato_swpmanager.projects_path
    end

    def tasks
      redirect_to lato_core.root_path and return false unless @superuser_admin

      @project = Project.find(params[:id])

      @tasks = Task.where(project_id: @project.id).order('end_date ASC')

      @deadline_tasks = @tasks.where('end_date <= ?', Date.today + 1).where.not(status: 'completed')
      @wait_tasks = @tasks.where(status: 'wait')
      @develop_tasks = @tasks.where(status: 'develop')
      @test_tasks = @tasks.where(status: 'test')
      @completed_tasks = @tasks.where(status: 'completed')

      if params[:task_id]
        @task = Task.find(params[:task_id])
      else
        @task = Task.new
      end

      if params[:init_date]
        @init_date = params[:init_date].to_date
        @end_date = @init_date + 6
      else
        @init_date = Date.yesterday
        @end_date = @init_date + 6
      end
    end

    def stats
      redirect_to lato_core.root_path and return false unless @superuser_admin

      @project = Project.find(params[:id])

      @tasks = Task.where(project_id: @project.id).order('end_date ASC')
      @wait_tasks = @tasks.where(status: 'wait')
      @develop_tasks = @tasks.where(status: 'develop')
      @test_tasks = @tasks.where(status: 'test')
      @completed_tasks = @tasks.where(status: 'completed')
      @collaborators = @project.collaborators
    end

    private def fetch_external_objects
      @clients = false
      @collaborators = Collaborator.all
      @superusers = LatoCore::Superuser.where('permission >= ?', swpmanager_getCollaboratorAdminSuperuserPermission)
    end

  end
end
