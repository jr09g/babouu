json.array!(@companies) do |company|
  json.extract! company, :id, :name, :email_domain, :category
  json.url company_url(company, format: :json)
end
