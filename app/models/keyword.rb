# frozen_string_literal: true

# Small wrapper around the notion api for grabbing my words...
class Keyword
  class << self
    def all
      client
        .get_page(ENV.fetch('NOTION_KEYWORDS_PAGE'))
        .rows
        .reject { |row| row.tags.include?('Known') }
    rescue StandardError => e
      Rails.logger.error "Notion integration not running! #{e.message}"
      []
    end

    private

    def client
      @client ||= NotionAPI::Client.new(ENV.fetch('NOTION_TOKEN'))
    end
  end
end
