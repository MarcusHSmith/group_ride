class AddSpeedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :speedArr, :integer
  end
end
