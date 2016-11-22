module LatoSwpmanager
  class Back::CollaboratorsController < Back::BackController

    before_action :check_user_is_admin, except: [:show]
    before_action :check_user_is_superadmin, only: [:destroy]

    def show
      # set correct collaborator profile (not admin user can only see its profile)
      if @superuser_is_admin
        @collaborator = Collaborator.find(params[:id])
      else
        @collaborator = @superuser_collaborator
      end

      # prepare data about collaborator projects and profile
      @projects = @collaborator.projects.where(status: 'develop').order('title ASC')
      @tasks = @collaborator.tasks.where(project_id: @projects.pluck(:id))

      # prepare data about collaborator timeline
      if params[:init_date]
        @init_date = params[:init_date].to_date
        @end_date = @init_date + 6
      else
        @init_date = Date.yesterday
        @end_date = @init_date + 6
      end
    end

    def index
      @collaborators = Collaborator.all.paginate(page: params[:page], per_page: 20).order('surname ASC')
    end

    def new
      @collaborator = Collaborator.new
    end

    def create
      collaborator = Collaborator.new(collaborator_params)

      if collaborator.save
        flash[:success] = "Collaborator created"
      else
        flash[:danger] = "Collaborator not created"
      end

      redirect_to lato_swpmanager.collaborators_path
    end

    def edit
      @collaborator = Collaborator.find(params[:id])
      # check superuser exist for collaborator
      check_superuser_exist(@collaborator)
    end

    def update
      collaborator = Collaborator.find(params[:id])

      if collaborator.update(collaborator_params)
        flash[:success] = "Collaborator updated"
      else
        flash[:danger] = "Collaborator not updated"
      end

      redirect_to lato_swpmanager.collaborators_path
    end

    def destroy
      collaborator = Collaborator.find(params[:id])
      collaborator.destroy

      flash[:success] = "Collaborator deleted"
      redirect_to lato_swpmanager.collaborators_path
    end

    # This function check superuser exist for collaborator and destroy it if
    # not exist.
    private def check_superuser_exist(collaborator)
      if collaborator.superuser_id
        superuser = LatoCore::Superuser.find_by(id: collaborator.superuser_id)
        collaborator.update(superuser_id: nil) unless superuser
      end
    end

  end
end
