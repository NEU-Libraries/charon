# frozen_string_literal: true

# This migration comes from minerva (originally 20190103213735)
class CreateMinervaRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :minerva_roles, &:timestamps
  end
end
