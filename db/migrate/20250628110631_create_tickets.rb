class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.integer :status, default: 0   # 0=open, 1=pending, 2=closed
      t.references :customer, foreign_key: { to_table: :users }
      t.references :agent, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end
  end
end
