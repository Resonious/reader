# frozen_string_literal: true

# Simple controller authentication where the user is required to input an API
# Key in order to proceed.
module KeyAuthentication
  extend ActiveSupport::Concern

  included do
    prepend_before_action :check_key
  end

  def check_key
    return if current_user.present?

    flash[:alert] = 'Not so fast.'
    session[:target] = request.fullpath
    redirect_to sign_in_path
  end
end
