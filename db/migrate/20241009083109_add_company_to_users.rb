class AddCompanyToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :company, :string
  end
end
