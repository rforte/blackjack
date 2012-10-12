class ApplicationController < ActionController::Base
  # protect_from_forgery
  
  protected
  
  def error(error_hash)
    if error_hash == Api::V1::GameErrors::UNHANDLED
      Rails.logger.error $!
      Rails.logger.error $@      
    end
    render :json => error_hash.merge({:type => "ERROR"}).to_json, :status => error_hash[:status]
  end
  
  def game_error(status, code, message)
    render :json => {:type => "ERROR", :code => code, :msg => message}.to_json, :status => status
  end
end
