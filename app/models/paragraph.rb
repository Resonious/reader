class Paragraph < ApplicationRecord
  belongs_to :book, inverse_of: :paragraphs

  after_initialize do
    self.content ||= ''
  end
end
