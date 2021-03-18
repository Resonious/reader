class Book < ApplicationRecord
  validates :slug, :name, presence: true

  after_initialize do
    self.content ||= ''
  end
end
