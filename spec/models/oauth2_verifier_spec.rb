require File.dirname(__FILE__) + '/../spec_helper'

describe Oauth2Verifier do
  fixtures :oauth_tokens
  before(:each) do
    @verifier = Oauth2Verifier.create :client_application => Factory.create(:client_application), :user=>Factory.create(:user)
  end

  it "should be valid" do
    @verifier.should be_valid
  end

  it "should have a code" do
    @verifier.code.should_not be_nil
  end

  it "should not have a secret" do
    @verifier.secret.should be_nil
  end

  it "should be authorized" do
    @verifier.should be_authorized
  end

  it "should not be invalidated" do
    @verifier.should_not be_invalidated
  end

  describe "exchange for oauth2 token" do
    before(:each) do
      @token = @verifier.exchange!
    end

    it "should invalidate verifier" do
      @verifier.should be_invalidated
    end

    it "should set user on token" do
      @token.user.should==@verifier.user
    end

    it "should set client application on token" do
      @token.client_application.should == @verifier.client_application
    end

    it "should be authorized" do
      @token.should be_authorized
    end

    it "should not be invalidated" do
      @token.should_not be_invalidated
    end
  end
end

# == Schema Information
#
# Table name: oauth_tokens
#
#  id                    :integer(4)      not null, primary key
#  user_id               :integer(4)
#  type                  :string(20)
#  client_application_id :integer(4)
#  token                 :string(40)
#  secret                :string(40)
#  callback_url          :string(255)
#  verifier              :string(20)
#  scope                 :string(255)
#  authorized_at         :datetime
#  invalidated_at        :datetime
#  valid_to              :datetime
#  created_at            :datetime
#  updated_at            :datetime
#

