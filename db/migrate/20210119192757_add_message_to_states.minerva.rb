# This migration comes from minerva (originally 20210119184915)
class AddMessageToStates < ActiveRecord::Migration[6.0]
  def change
    add_column :minerva_states, :message, :string
  end
end
