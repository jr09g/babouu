json.array!(@expense_report_statuses) do |expense_report_status|
  json.extract! expense_report_status, :id
  json.url expense_report_status_url(expense_report_status, format: :json)
end
