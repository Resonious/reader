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
        params Entities::Book.documentation
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
          present book, with: Entities::Book
        end
      end
    end
  end
end
