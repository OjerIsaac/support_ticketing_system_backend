class AddAuthenticationTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :authentication_token, :string
    add_index :users, :authentication_token
  end
end
