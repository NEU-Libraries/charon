# frozen_string_literal: true

class User < ApplicationRecord
  enumeration :capacity

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  include Blacklight::AccessControls::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_initialize do |user|
    if user.capacity.nil?
      user.capacity = Capacity.user
    end
  end

  def dev?
    self.capacity == :developer
  end

  def admin?
    self.capacity == :administrator
  end
end
