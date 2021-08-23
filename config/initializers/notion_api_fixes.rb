# frozen_string_literal: true

## We get a 400 error if we don't include timezone!
#module QueryCollectionBodyPatch
#  def query_collection_body(*)
#    super.tap { |r| r[:loader][:userTimeZone] = 'Asia/Tokyo' }
#  end
#end
#
#Utils::CollectionViewComponents.singleton_class.prepend QueryCollectionBodyPatch
