class AddDefaultToStatus < ActiveRecord::Migration[8.0]
  def change
    change_column_default :articles, :status, from:nil, to: 'active'
  end
end
