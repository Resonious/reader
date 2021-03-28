# frozen_string_literal: true

# Main class for the app. Has many paragraphs. Add content with add_content,
# and paragraphs will be parsed out automatically.
class Book < ApplicationRecord
  has_many :paragraphs, inverse_of: :book do
    def at(index)
      find_by(index: index)
    end

    def at!(index)
      find_by!(index: index)
    end
  end

  validates :slug, presence: true

  after_initialize do
    self.content ||= ''
  end

  before_validation do
    self.name ||= slug
  end

  def last_paragraph
    paragraphs.last || paragraphs.build(index: 0)
  end

  def add_content(text)
    paragraph_texts = text.split(/　　+/)

    # When we receive one paragraph that ends in 2FWS, our usual algorithm
    # doesn't quite work. We want to create an empty paragraph after appending.
    paragraph_texts << '' if paragraph_texts.size == 1 && text =~ /　　+$/

    append_to_last_paragraph(paragraph_texts)

    paragraph_texts.each do |paragraph_text|
      paragraphs.create! index: paragraphs.size, content: paragraph_text
    end
  end

  private

  def append_to_last_paragraph(paragraph_texts)
    if last_paragraph.content.ends_with?('　') &&
       paragraph_texts.first.starts_with?('　')
      last_paragraph.update! content: last_paragraph.content[0..-2]
      paragraph_texts[0] = paragraph_texts[0][1..-1]
    else
      current_paragraph_text = paragraph_texts.shift
      last_paragraph.update! content: last_paragraph.content + current_paragraph_text
    end
  end
end
