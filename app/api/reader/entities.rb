module Reader
  module Entities
    class Book < Grape::Entity
      expose :slug
      expose :name
      expose :content
      expose :idx
    end
  end
end
