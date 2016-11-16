module LatoSwpmanager
  class Back::TasksController < Back::BackController

    before_action :check_user_is_admin, except: [:show, :update]

    def show
      @task = Task.find(params[:id])
      @project = Project.find(@task.project_id)
      # check user is part of project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? @project))
        flash[:warning] = "You can't see this task"
        redirect_to lato_core.root_path and return false
      end
      # check user is the collaborator of task (if is not the project manager)
      if (!@superuser_is_superadmin && @superuser.id != @project.superuser_manager_id &&
          @superuser_collaborator && @superuser_collaborator.id != @task.collaborator_id)
        flash[:warning] = "You can't see this task"
        redirect_to lato_core.root_path and return false
      end
      # prepare message task
      @task_message = TaskMessage.new
    end

    def create
      # create task
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
      # find edit task
      task = Task.find(params[:id])
      # check superuser is part of the project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? task.project))
        flash[:warning] = "You can't edit this task"
        redirect_to lato_swpmanager.root_path and return false
      end
      # redirecto to project tasks page
      redirect_to lato_swpmanager.project_tasks_path(id: task.project_id, task_id: task.id)
    end

    def update
      # find task
      task = Task.find(params[:id])
      # check superuser is part of the project
      if (!(superuser_is_part_of_project? task.project))
        flash[:warning] = "You can't edit this task"
        redirect_to lato_swpmanager.root_path and return false
      end
      # update task
      if task.update(task_params)
        flash[:success] = "Task updated"
      else
        flash[:danger] = "Task not updated"
      end

      redirect_to lato_swpmanager.project_tasks_path(id: task.project_id)
    end

    def destroy
      # find task
      task = Task.find(params[:id])
      # check superuser is part of the project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? task.project))
        flash[:warning] = "You can't edit this task"
        redirect_to lato_swpmanager.root_path and return false
      end
      # destroy task
      task.destroy
      # redirect to correct page
      flash[:success] = "Task deleted"
      redirect_to lato_swpmanager.project_tasks_path(id: task.project_id)
    end

  end
end
