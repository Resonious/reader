# frozen_string_literal: true

# The usual Rails base class for all controllers.
class ApplicationController < ActionController::Base
  def current_user
    key = cookies[:api_key]
    return nil if key.blank?

    @current_user ||= APIKey.find_by(key: key)
  end
end
