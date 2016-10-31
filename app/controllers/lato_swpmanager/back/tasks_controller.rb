module LatoSwpmanager
  class Back::TasksController < Back::BackController

    before_action do
      view_setCurrentVoice('swpmanager_projects')
    end

    def show
      @task = Task.find(params[:id])
      @project = Project.find(@task.project_id)
      @task_message = TaskMessage.new
    end

    def create
      redirect_to lato_core.root_path and return false unless @superuser_admin

      task = Task.new(task_params)

      # save superuser creator
      task.superuser_creator_id = @superuser.id

      if task.save
        flash[:success] = "Task created"
      else
        flash[:danger] = "Task not created"
      end

      redirect_to lato_swpmanager.project_tasks_path(id: task.project_id)
    end

    def edit
      redirect_to lato_core.root_path and return false unless @superuser_admin

      task = Task.find(params[:id])
      redirect_to lato_swpmanager.project_tasks_path(id: task.project_id, task_id: task.id)
    end

    def update
      task = Task.find(params[:id])

      if task.update(task_params)
        flash[:success] = "Task updated"
      else
        flash[:danger] = "Task not updated"
      end

      if params[:task_collaborator_update]
        redirect_to lato_swpmanager.task_path(task.id)
      else
        redirect_to lato_swpmanager.project_tasks_path(id: task.project_id)
      end
    end

    def destroy
      redirect_to lato_core.root_path and return false unless @superuser_admin

      task = Task.find(params[:id])
      task.destroy

      flash[:success] = "Task deleted"
      redirect_to lato_swpmanager.project_tasks_path(id: task.project_id)
    end

  end
end
