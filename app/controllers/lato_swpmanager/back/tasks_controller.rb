module LatoSwpmanager
  class Back::TasksController < Back::BackController

    before_action do
      view_setCurrentVoice('swpmanager_projects')
    end

    def show
      @task = Task.find(params[:id])
      @project = Project.find(@task.project_id)
      # check user is manager of project
      if (!@superuser_superadmin && @superuser_admin && !(@project.superuser_manager_id === @superuser.id))
        redirect_to lato_core.root_path and return false
      end
      # prepare message task
      @task_message = TaskMessage.new
    end

    def create
      # check user is admin
      redirect_to lato_core.root_path and return false unless @superuser_admin
      # create teask
      task = Task.new(task_params)
      # save superuser creator
      task.superuser_creator_id = @superuser.id
      # save task
      if task.save
        flash[:success] = "Task created"
      else
        flash[:danger] = "Task not created"
      end

      redirect_to lato_swpmanager.project_tasks_path(id: task.project_id)
    end

    def edit
      # check user is admin
      redirect_to lato_core.root_path and return false unless @superuser_admin
      # edit task
      task = Task.find(params[:id])
      # redirecto to project tasks page
      redirect_to lato_swpmanager.project_tasks_path(id: task.project_id, task_id: task.id)
    end

    def update
      # find task
      task = Task.find(params[:id])
      # update task
      if task.update(task_params)
        flash[:success] = "Task updated"
      else
        flash[:danger] = "Task not updated"
      end
      # exec correct redirect
      if params[:task_collaborator_update]
        redirect_to lato_swpmanager.task_path(task.id)
      else
        redirect_to lato_swpmanager.project_tasks_path(id: task.project_id)
      end
    end

    def destroy
      # check user is admin
      redirect_to lato_core.root_path and return false unless @superuser_admin
      # find task
      task = Task.find(params[:id])
      # destroy task
      task.destroy
      # redirect to correct page
      flash[:success] = "Task deleted"
      redirect_to lato_swpmanager.project_tasks_path(id: task.project_id)
    end

  end
end
