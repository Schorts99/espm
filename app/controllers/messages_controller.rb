class MessagesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_message, except: [:index, :new, :create]

  def index
    @messages = Message.all.order('created_at DESC')
  end

  def new
    @message = current_user.messages.build
  end

  def create
    @message = current_user.messages.build(message_params)

    if @message.save
      redirect_to root_path
    else
      flash[:alert] = "Hubo un error al crear el mensaje, intente de nuevo"
      render 'new'
    end
  end

  def update
    if @message.update(message_params)
      flash[:notice] = "Mensaje actualizado"
      redirect_to message_path
    else
      flash[:alert] = "Hubo un error al actualizar el mensaje, intente de nuevo"
      render 'edit'
    end
  end

  def destroy
    @message.destroy
    redirect_to root_path
  end

  private
    def find_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:title, :description)
    end
end
