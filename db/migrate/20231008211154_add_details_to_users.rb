class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :string
    add_column :users, :first_name, :string
    add_column :users, :middle_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :bank_account, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :address, :string
    add_column :users, :avatar, :string
  end
end
