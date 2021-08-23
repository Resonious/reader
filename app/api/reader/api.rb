# frozen_string_literal: true

module Reader
  # This is the API you can use to populate books.
  class API < Grape::API
    version 'v1', using: :path
    format :json

    helpers do
      def api_key
        @api_key ||= begin
          username = Rack::Auth::Basic::Request.new(env)&.username
          APIKey.find_by(key: username.encode('UTF-8')) if username
        end
      rescue Encoding::UndefinedConversionError
        nil
      end

      def authenticate!
        error!('Unauthorized', 401) unless api_key
      end
    end

    resource :books do
      desc 'Create or amend a book' do
        params Entities::Book.documentation
      end
      params do
        requires :slug, type: String, desc: 'Book slug'
        requires :idx, type: Integer, desc: 'New "idx" value'
        optional :content, type: String, desc: 'Content to append'
      end
      route_param :slug do
        post do
          authenticate!
          book = Book.find_or_initialize_by(slug: params[:slug])
          book.idx = params[:idx]
          book.add_content params[:content] if params[:content].present?
          book.save!
          present book, with: Entities::Book
        end
      end

      desc 'Update book name' do
        params Entities::Book.documentation
      end
      params do
        requires :slug, type: String, desc: 'Book slug'
        requires :name, type: String, desc: 'New name'
      end
      route_param :slug do
        patch do
          authenticate!
          book = Book.find_or_initialize_by(slug: params[:slug])
          book.name = params[:name]
          book.save!
          present book, with: Entities::Book
        end
      end

      desc 'View a book. Includes last paragraph.'
      params do
        optional :p, type: Integer, desc: 'Paragraph index'
      end
      route_param :slug do
        get do
          authenticate!
          book = Book.find_or_initialize_by(slug: params[:slug])
          present book, with: Entities::Book, p: params[:p]
        end
      end
    end
  end
end
