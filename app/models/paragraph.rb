class Paragraph < ApplicationRecord
  belongs_to :book, inverse_of: :paragraphs

  after_initialize do
    self.content ||= ''
  end

  def first?
    index == 0
  end

  def last?
    index == book.paragraphs.size - 1
  end

  def lines
    @lines ||= content.split('　')
  end
end
