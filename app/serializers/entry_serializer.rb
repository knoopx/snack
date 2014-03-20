class EntrySerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :excerpt, :author, :url, :created_at
  has_one :feed
end
