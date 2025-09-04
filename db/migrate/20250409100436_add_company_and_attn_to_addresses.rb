# frozen_string_literal: true

class AddCompanyAndAttnToAddresses < ActiveRecord::Migration[7.2]
  def change
    add_column :addresses, :company, :string
    add_column :addresses, :attn, :string
  end
end
