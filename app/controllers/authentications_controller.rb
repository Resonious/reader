# frozen_string_literal: true

# Ask user to sign in using API Key
class AuthenticationsController < ApplicationController
  layout 'waves'

  def new; end

  def create
    key = params[:key]
    api_key = APIKey.find_by(key: key)

    if api_key.present?
      cookies[:api_key] = { value: api_key.key, expires: 3.days }
      flash[:notice] = 'Welcome!'
      redirect_to session.delete(:target) || books_path
    else
      flash[:alert] = 'No dice.'
      redirect_to sign_in_path
    end
  end
end
