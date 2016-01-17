class ResponsesController < ApplicationController
  before_filter :load_chat
  before_filter :load_response, only: [:show, :edit, :update, :destroy]

  def index
    @responses = @chat.responses

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def new
    @response = Response.new()

    respond_to do |format|
      format.html
    end
  end

  def create
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
  end

  def destroy
  end

  private

  def load_chat
    @chat = Chat.where(_id: params[:chat_id], telegram_id: params[:telegram_id].to_i).first

    if (@chat.blank?)
      error_404
      return
    end
  end

  def load_response
    @response = @chat.responses.find(params[:id])
  end
end
