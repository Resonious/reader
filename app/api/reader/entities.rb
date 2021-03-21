module Reader
  module Entities
    class FullBook < Grape::Entity
      expose :slug
      expose :name
      expose :content
      expose :idx
    end

    class PartialBook < Grape::Entity
      expose :slug
      expose :name
      expose :content do |book|
        book.content.truncate(100)
      end
      expose :idx
    end
  end
end
