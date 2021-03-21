class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find_by!(slug: params[:id])
    @title = @book.name
  end
end
