# frozen_string_literal: true

# Proxy to Jisho.org (since they don't allow CORS)
class LookupsController < ApplicationController
  def new
    keyword = params[:q]
    url = "https://jisho.org/api/v1/search/words?keyword=#{CGI.escape(keyword)}"
    response = Faraday.get(url)

    render inline: response.body,
           content_type: 'application/json',
           status: response.status
  end
end
