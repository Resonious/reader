class Book < ApplicationRecord
  validates :slug, presence: true

  after_initialize do
    self.content ||= ''
  end

  before_validation do
    self.name ||= slug
  end
end
