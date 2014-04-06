class ListController < ApplicationController
  def checkAuthentication
    if !cookies[:SESSION]
      redirect_to '/users/login'
      return false
    end

    return true
  end

  def current_user
    cookies[:SESSION].split(':')[0]
  end

  def view
    if checkAuthentication()
      @list = List.where(:id => params[:id]).first
      @current_user = current_user

      if !@list.available
        redirect_to '/'
        return
      end

      if @list.user.username != current_user
        redirect_to '/'
        return
      end
    end
  end

  def toggle_task
    if checkAuthentication()
      list = List.where(:id => params[:id]).first

      if list.user.username != current_user
        redirect_to '/'
        return
      end

      task = list.tasks.where(:id => params[:taskId]).first

      if task.closed
        task.open!
      else
        task.close!
      end

      task.save!
    end

    head :ok
  end

  def new_task
    if checkAuthentication()
      list = List.where(:id => params[:id]).first

      if list.user.username != current_user
        redirect_to '/'
        return
      end

      list.tasks.build(:title => params[:title])
      list.save!
    end

    head :ok
  end

  def delete_task
    if checkAuthentication()
      list = List.where(:id => params[:id]).first

      if list.user.username != current_user
        redirect_to '/'
        return
      end

      list.tasks.where(:id => params[:taskId]).first.destroy
      list.save!
    end

    head :ok
  end

  # def reopen_list
  #   if checkAuthentication()
  #     list = List.where(:id => params[:id]).first

  #     if list.user.username != current_user
  #       redirect_to '/'
  #       return
  #     end

  #     list.tasks.each do |task|
  #       task.open!
  #       task.save!
  #     end

  #     list.save!
  #   end

  #   head :ok
  # end
end