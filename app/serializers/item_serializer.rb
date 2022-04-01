class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant_id
  # def self.format_items(items)
  #   {
  #     "type": "object",
  #     "properties": items.map do |item|
  #       {
  #         "id": { "type": item.id.class},
  #         "type": { "type": "string"},
  #         "attributes": items.
  #       },
  #
  #   }
  # end
end
