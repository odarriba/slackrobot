class ProcessorController < ApplicationController
  protect_from_forgery with: :null_session
  
  def receive
    render json: {}
  end
end
