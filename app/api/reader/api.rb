module Reader
  class API < Grape::API
    version 'v1', using: :path
    format :json

    helpers do
      def api_key
        @api_key ||= (
          username = Rack::Auth::Basic::Request.new(env).username
          APIKey.find_by(key: username.encode('UTF-8'))
        )
      rescue Encoding::UndefinedConversionError
        nil
      end

      def authenticate!
        error!('Unauthorized', 401) unless api_key
      end
    end

    resource :books do
      desc 'Create or amend a book' do
        params Entities::FullBook.documentation
      end
      params do
        requires :slug, type: String, desc: 'Book slug'
        requires :idx, type: Integer, desc: 'New "idx" value'
        requires :content, type: String, desc: 'Content to append'
      end
      route_param :slug do
        post do
          authenticate!
          book = Book.find_or_initialize_by(slug: params[:slug])
          book.content += params[:content]
          book.idx = params[:idx]
          book.save!
          present book, with: Entities::PartialBook
        end
      end

      desc 'Update book name' do
        params Entities::FullBook.documentation
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
          present book, with: Entities::PartialBook
        end
      end

      desc 'View a book and its contents (all in one big resposne!! maybe bad!!)'
      route_param :slug do
        get do
          authenticate!
          book = Book.find_or_initialize_by(slug: params[:slug])
          present book, with: Entities::FullBook
        end
      end
    end
  end
end
