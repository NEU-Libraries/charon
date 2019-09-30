# frozen_string_literal: true

describe Workflow do
  let(:project) { FactoryBot.create_for_repository(:project) }
  let(:admin_user) { create(:admin) }

  describe 'project helper method' do
    it 'returns a Project based on the AUID in Minerva' do
      mp = Minerva::Project.create(auid: project.id)
      mu = Minerva::User.create(auid: admin_user.id)
      w = Workflow.create(task_list: Task.all.map(&:name), project_id: mp.id, creator_id: mu.id)
      expect(w.project).to eq project
    end
  end
end
