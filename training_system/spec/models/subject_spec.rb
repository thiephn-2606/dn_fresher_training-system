require 'rails_helper'

RSpec.describe Subject, type: :model do
  subject { FactoryBot.create :subject}
  let!(:task) {subject.tasks.create(subject_id: subject.id)}
  let!(:task) {subject.tasks.create(name: "a", description: "a", duration: 2)}

  describe "associations" do
    it { should have_many(:course_subjects) }
    it { should have_many(:tasks) }
    it { should accept_nested_attributes_for(:tasks) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:duration) }

    it "should not be valid if at least one subject task" do
      task.valid?
    end
  end
end
