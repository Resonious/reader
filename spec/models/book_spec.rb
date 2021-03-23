# frozen_string_literal: true

require 'rails_helper'

describe Book do
  describe '#add_content' do
    it 'creates a new paragraph' do
      book = Book.create! slug: 'test'
      book.add_content 'here is my content'

      expect(book.paragraphs.size).to eq 1
      expect(book.paragraphs.first.content).to eq 'here is my content'
    end

    it 'adds onto last paragraph' do
      book = Book.create! slug: 'test'
      book.add_content 'here is my content'
      book.add_content ' and here is more'

      expect(book.paragraphs.size).to eq 1
      expect(book.paragraphs.first.content).to eq 'here is my content and here is more'
    end

    it 'splits paragraphs by double fullwidth spaces' do
      book = Book.create! slug: 'test'
      book.add_content 'paragraph content 1　　paragraph content 2'

      expect(book.paragraphs.size).to eq 2
      expect(book.paragraphs.first.content).to eq 'paragraph content 1'
      expect(book.paragraphs.last.content).to eq 'paragraph content 2'
    end

    it 'handles multiple paragraphs in one go' do
      book = Book.create! slug: 'test'
      book.add_content 'paragraph content 1　　paragraph content 2　　paragraph content 3'

      expect(book.paragraphs.size).to eq 3
      expect(book.paragraphs[0].content).to eq 'paragraph content 1'
      expect(book.paragraphs[1].content).to eq 'paragraph content 2'
      expect(book.paragraphs[2].content).to eq 'paragraph content 3'
    end
  end
end
