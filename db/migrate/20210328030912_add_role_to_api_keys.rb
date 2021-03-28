class AddRoleToAPIKeys < ActiveRecord::Migration[6.1]
  def change
    add_column :api_keys, :role, :string, index: true, default: 'unspecified'
  end
end
