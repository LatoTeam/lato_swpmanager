module LatoSwpmanager
  class Back::TaskCategoriesController < Back::BackController

    before_action :check_user_is_admin

    before_action do
      view_setCurrentVoice('swpmanager_projects')
    end

    def index
      # find project
      @project = Project.find(params[:project_id])
      # check user is part of project
      if (!@superuser_superadmin && !(superuser_is_part_of_project? @project))
        flash[:warning] = "You can't see this task"
        redirect_to lato_core.root_path and return false
      end
      # find datas
      @task_categories = TaskCategory.where(project_id: @project.id)
      @task_category = TaskCategory.new
    end

    def create
      task_category = TaskCategory.new(task_category_params)
      # save task
      if task_category.save
        flash[:success] = "Category created"
      else
        flash[:danger] = "Category not created"
      end

      redirect_to lato_swpmanager.task_categories_path(project_id: task_category.project_id)
    end

    def destroy
      # find task
      task_category = TaskCategory.find(params[:id])
      # check superuser is part of the project
      if (!@superuser_is_superadmin && !(superuser_is_part_of_project? task_category.project))
        flash[:warning] = "You can't edit this category"
        redirect_to lato_swpmanager.root_path and return false
      end
      # destroy category
      task_category.destroy
      # redirect to correct page
      flash[:success] = "Category deleted"
      redirect_to lato_swpmanager.task_categories_path(project_id: task_category.project_id)
    end

  end
end
