# frozen_string_literal: true

# Simple container of a randomly generated value that authorizes someone to use
# the app.
class APIKey < ApplicationRecord
  after_initialize do
    self.key ||= SecureRandom.base64(30)
  end
end
