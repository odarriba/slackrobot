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
    @response = Response.new(response_params)
    @response.chat = @chat

    respond_to do |format|
      format.html {
        if (@response.save)
          flash[:info] = "Response sucessfully created."
          redirect_to responses_path(chat_id: @chat.id, telegram_id: @chat.telegram_id)
        else
          render :action => :new
        end
      }
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      format.html {
        if (@response.update_attributes(response_params))
          flash[:info] = "Response sucessfully updated."
          redirect_to responses_path(chat_id: @chat.id, telegram_id: @chat.telegram_id)
        else
          render :action => :edit
        end
      }
    end
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

  def response_params
    clean_params = params.require(:response).permit(:queries, :responses, :markdown, :reply)
    clean_params[:queries] = clean_params[:queries].split("\r\n")
    clean_params[:responses] = clean_params[:responses].split("\r\n")

    clean_params
  end
end
