json.array!(@expense_reports) do |expense_report|
  json.extract! expense_report, :id, :name, :start_date, :end_date
  json.url expense_report_url(expense_report, format: :json)
end
