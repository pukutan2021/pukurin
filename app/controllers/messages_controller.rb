class MessagesController < ApplicationController
  before_action :set_message, only: [:edit, :update, :destroy, :show]
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]

  def index
    @messages = Message.includes(:user).order('created_at DESC')
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def update
    if @message.update(message_params)
      redirect_to message_path(@message)
    else
      render :edit
    end
  end

  def destroy
    @message.destroy
    redirect_to root_path
  end

  private

  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def contributor_confirmation
    if current_user != @message.user
      redirect_to root_path
    end
  end
end
