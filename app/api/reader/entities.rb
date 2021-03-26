# frozen_string_literal: true

# Reader Entities
module Reader
  module Entities
    # Book entity
    class Book < Grape::Entity
      expose :slug
      expose :name
      expose :idx
      expose :p do |book, options|
        index = options[:p] || book.paragraphs.size - 1
        book.paragraphs.at(index)&.index
      end
      expose :content do |book, options|
        index = options[:p] || book.paragraphs.size - 1
        book.paragraphs.at(index)&.content
      end
    end
  end
end
