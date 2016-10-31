module LatoSwpmanager
  class Back::ClientsController < Back::BackController

    before_action do
      view_setCurrentVoice('swpmanager_clients')
    end

    def index
      redirect_to lato_core.root_path and return false unless @superuser_admin

      @clients = Client.all.paginate(page: params[:page], per_page: 20).order('name ASC')
    end

    def new
      redirect_to lato_core.root_path and return false unless @superuser_admin

      @client = Client.new
    end

    def create
      redirect_to lato_core.root_path and return false unless @superuser_admin

      client = Client.new(client_params)

      if client.save
        flash[:success] = "Client created"
      else
        flash[:danger] = "Client not created"
      end

      redirect_to lato_swpmanager.clients_path
    end

    def show
      redirect_to lato_core.root_path and return false unless @superuser_admin

      redirect_to edit_lato_client_path(params[:id])
    end

    def edit
      redirect_to lato_core.root_path and return false unless @superuser_admin

      @client = Client.find(params[:id])
    end

    def update
      redirect_to lato_core.root_path and return false unless @superuser_admin

      client = Client.find(params[:id])

      if client.update(client_params)
        flash[:success] = "Client updated"
      else
        flash[:danger] = "Client not updated"
      end

      redirect_to lato_swpmanager.clients_path
    end

    def destroy
      redirect_to lato_core.root_path and return false unless @superuser_admin

      client = Client.find(params[:id])
      client.destroy

      flash[:success] = "Client deleted"
      redirect_to lato_swpmanager.clients_path
    end

  end
end
