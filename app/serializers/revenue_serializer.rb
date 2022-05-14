class RevenueSerializer
  include JSONAPI::Serializer
  attributes :revenue do |object|
    object.revenue
  end
end
