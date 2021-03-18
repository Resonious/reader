class APIKey < ApplicationRecord
  after_initialize do
    self.key ||= SecureRandom.base64(30)
  end
end
