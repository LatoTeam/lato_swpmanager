module LatoSwpmanager
  class Back::TaskMessagesController < Back::BackController

    def create
      task_message = TaskMessage.new(task_message_params)
      # save superuser creator
      task_message.superuser_creator_id = @superuser.id
      # save message
      task_message.save
      # update page without refresh
      @task = Task.find(task_message.task_id)
      respond_to do |format|
        format.js { render action: 'functions/update_conversation'}
      end
    end

    def destroy
      task_message = TaskMessage.find(params[:id])
      # check user is admin or the creator of message
      if @superuser_is_admin || @superuser.id === task_message.superuser_creator_id
        task_message.destroy
        flash[:success] = "Message deleted"
      else
        flash[:danger] = "You can't delete the message"
      end
      # redirect
      redirect_to lato_swpmanager.task_path(id: task_message.task_id)
    end

  end
end
