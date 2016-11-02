module LatoSwpmanager
  class Back::CollaboratorsController < Back::BackController

    before_action do
      view_setCurrentVoice('swpmanager_collaborators')
    end

    def index
      redirect_to lato_core.root_path and return false unless @superuser_admin

      @collaborators = Collaborator.all.paginate(page: params[:page], per_page: 20).order('surname ASC')
    end

    def new
      redirect_to lato_core.root_path and return false unless @superuser_admin

      @collaborator = Collaborator.new
    end

    def create
      redirect_to lato_core.root_path and return false unless @superuser_admin

      collaborator = Collaborator.new(collaborator_params)

      if collaborator.save
        flash[:success] = "Collaborator created"
      else
        flash[:danger] = "Collaborator not created"
      end

      redirect_to lato_swpmanager.collaborators_path
    end

    def show
      # set coorect collaborator profile
      if @superuser_admin
        @collaborator = Collaborator.find(params[:id])
      else
        @collaborator = @superuser_collaborator
      end

      # active correct menu voice if user see its profile
      if @superuser_collaborator && @superuser_collaborator === @collaborator
        view_setCurrentVoice('swpmanager_profile')
      end

      @projects = @collaborator.projects.where(status: 'develop').order('title ASC')
      @tasks = @collaborator.tasks

      if params[:init_date]
        @init_date = params[:init_date].to_date
        @end_date = @init_date + 6
      else
        @init_date = Date.yesterday
        @end_date = @init_date + 6
      end
    end

    def edit
      redirect_to lato_core.root_path and return false unless @superuser_admin

      @collaborator = Collaborator.find(params[:id])
      check_superuser_exist(@collaborator)
    end

    def update
      redirect_to lato_core.root_path and return false unless @superuser_admin

      collaborator = Collaborator.find(params[:id])

      if collaborator.update(collaborator_params)
        flash[:success] = "Collaborator updated"
      else
        flash[:danger] = "Collaborator not updated"
      end

      redirect_to lato_swpmanager.collaborators_path
    end

    def destroy
      redirect_to lato_core.root_path and return false unless @superuser_admin

      collaborator = Collaborator.find(params[:id])
      collaborator.destroy

      flash[:success] = "Collaborator deleted"
      redirect_to lato_swpmanager.collaborators_path
    end

    private def check_superuser_exist(collaborator)
      if collaborator.superuser_id
        superuser = LatoCore::Superuser.find_by(id: collaborator.superuser_id)
        collaborator.update(superuser_id: nil) unless superuser
      end
    end

  end
end
