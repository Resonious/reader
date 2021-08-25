# frozen_string_literal: true

# Front end for books
class BooksController < ApplicationController
  include KeyAuthentication

  def index
    @title = 'Select a book'
    @books = Book.all
    render layout: 'waves'
  end

  def show
    redirect_to book_path(params[:slug], '0') and return if params[:p].nil?

    @book = Book.find_by!(slug: params[:slug])
    @paragraph = @book.paragraphs.at(params[:p])

    cookies["book_#{@book.slug}"] = { value: params[:p] }
  end

  def resume; end
end
