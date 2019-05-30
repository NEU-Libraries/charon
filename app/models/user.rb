# frozen_string_literal: true

class User < ApplicationRecord
  enumeration :capacity
  has_many :roles, dependent: :destroy

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  include Blacklight::AccessControls::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  after_initialize do |user|
    user.capacity = Capacity.user if user.capacity.nil?
  end

  def dev?
    capacity == :developer
  end

  def admin?
    dev? || capacity == :administrator
  end

  def projects; end

  def role(project)
    return nil if project.blank? || project.user_registry_id.blank?
    # stubbed role for admin users
    return Role.new(user: self, user_registry: project.user_registry, designation: Designation.manager) if admin?

    roles.find_by(user_registry_id: project.user_registry.id)
  end

  def designation(project)
    role(project).designation
  end

  def to_s
    # Blacklight presentation string
    "#{first_name} #{last_name}"
  end
end
