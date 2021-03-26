# frozen_string_literal: true

# Proxy to Jisho.org (since they don't allow CORS)
class LookupsController < ApplicationController
  def new
    keyword = params[:q]
    response = Faraday.get("https://jisho.org/api/v1/search/words?keyword=#{keyword}")

    render inline: response.body,
           content_type: 'application/json',
           status: response.status
  end
end
