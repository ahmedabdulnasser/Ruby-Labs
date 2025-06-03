class AddDefaultToReportsCount < ActiveRecord::Migration[8.0]
  def change
    change_column_default :articles, :reports_count, from: nil, to: 0
  end
end
