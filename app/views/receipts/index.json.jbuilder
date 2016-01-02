json.array!(@receipts) do |receipt|
  json.extract! receipt, :id, :receipt_desc, :price
  json.url receipt_url(receipt, format: :json)
end
