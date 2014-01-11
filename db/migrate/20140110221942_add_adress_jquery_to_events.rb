class AddAdressJqueryToEvents < ActiveRecord::Migration
  def change
    add_column :events, :address_latitude, :string
    add_column :events, :address_longitude, :string
    add_column :events, :address_locality, :string
    add_column :events, :address_country, :string
  end
end
