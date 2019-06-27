# frozen_string_literal: true

module Minerva
  class WorkflowsController < ApplicationController
    include Minerva::Base::Workflows

    layout 'application'

    def assign; end

    def claim; end

    def history; end
  end
end
