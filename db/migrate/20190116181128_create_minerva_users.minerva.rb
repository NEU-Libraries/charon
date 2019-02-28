# frozen_string_literal: true

# This migration comes from minerva (originally 20190103213703)
class CreateMinervaUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :minerva_users, &:timestamps
  end
end
