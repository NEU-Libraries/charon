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

  def is_developer?
  end

  def is_admin?
  end
end
