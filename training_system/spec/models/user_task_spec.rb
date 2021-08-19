require 'rails_helper'

RSpec.describe UserTask, type: :model do
  describe "associations" do
    it { should belong_to(:user_course_subject) }
    it { should belong_to(:task) }
  end

  describe "validations" do
    it { should define_enum_for(:status).with([:init, :in_progress, :finished]) }
  end
end
