# frozen_string_literal: true

# Front end for books
class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    redirect_to book_path(params[:slug], '0') and return if params[:p].nil?

    @book = Book.find_by!(slug: params[:slug])
    @paragraph = @book.paragraphs.at(params[:p])
  end
end
