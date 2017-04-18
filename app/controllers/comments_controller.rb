class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message
  before_action :find_comment, except: [:create]

  def create
    @comment = @message.comments.create(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to message_path(@message)
    else
      render 'new'
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to message_path(@message)
    else
      flash[:alert] = "Hubo un error al crear el comentario, intente de nuevo"
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    redirect_to message_path(@message)
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end

    def set_message
      @message = Message.find(params[:message_id])
    end

    def find_comment
      @comment = @message.comments.find(params[:id])
    end
end
