# frozen_string_literal: true

FactoryBot.define do
  factory :workflow do
    title      { Faker::Company.name }
    project_id { Minerva::Project.create(auid: FactoryBot.create_for_repository(:project).noid).id }
    creator_id { Minerva::User.create(auid: create(:user).id).id }
    task_list  { Task.all.map(&:name).to_s }
    ordered    { true }
  end
end
