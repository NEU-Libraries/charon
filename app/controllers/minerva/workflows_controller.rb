# frozen_string_literal: true

module Minerva
  class WorkflowsController < ApplicationController
    include Minerva::Base::Workflows
    def new
      super
    end
  end
end
