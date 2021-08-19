require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.create :user }

  describe "associations" do
    it { should have_many(:courses) }
    it { should have_many(:user_courses) }
  end

  describe "validations" do
    it { should have_secure_password }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(Settings.name_maxlen) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(Settings.email_maxlen) }
    it { should validate_length_of(:password).is_at_least(Settings.pass_minlen) }
    it { should define_enum_for(:roles).with([:trainee, :trainer, :admin]) }
  end

  describe "scope" do
    it "find user in course" do
      expect(User.user_in_course([1, 2])).to eq([User.first, User.second])
    end

    it "find user not in course" do
      expect(User.user_not_course([1, 2])).to_not eq([User.first, User.second])
    end
  end

  describe ".digest" do
    let(:digest) {User.digest("thiephuynh")}

    it "not nil" do
      expect(digest).not_to be nil
    end

    it "return a string" do
      expect(digest).to be_kind_of String
    end

    it "has length 60 character" do
      expect(digest.length).to eq(60)
    end
  end

  describe "#downcase_email" do
    it "downcase email before save calllback" do
      subject.reload.email == Faker::Internet.email
    end
  end
end