json.array!(@received_expense_reports) do |received_expense_report|
  json.extract! received_expense_report, :id
  json.url received_expense_report_url(received_expense_report, format: :json)
end
