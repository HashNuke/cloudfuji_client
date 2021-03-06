require 'spec_helper'

describe "Cloudfuji::User" do
  
  describe "valid?" do
    it "should post_command to valid_unity_url with email and pass in params" do
      params = {:email => "test@example.com", :pass => "GoCloudfuji"}
      Cloudfuji::Command.should_receive(:post_command).with(Cloudfuji::Base.valid_unity_url, params)
      Cloudfuji::User.valid?(params[:email], params[:pass])
    end
  end

  describe "exists?" do
    it "should post_command to exists_unity_url with email in params" do
      params = {:email => "test@example.com"}
      Cloudfuji::Command.should_receive(:post_command).with(Cloudfuji::Base.exists_unity_url, params)
      Cloudfuji::User.exists?(params[:email])
    end
  end

  describe "invite" do
    it "should post_command to invite_unity_url with email in params" do
      params = {:email => "test@example.com"}
      Cloudfuji::Command.should_receive(:post_command).with(Cloudfuji::Base.invite_unity_url, params)
      Cloudfuji::User.invite(params[:email])
    end
  end

  describe "pending_invites" do
    it "should get_command from pending_invites_url with no params" do
      params = {}
      Cloudfuji::Command.should_receive(:get_command).with(Cloudfuji::Base.pending_invites_unity_url, params)
      Cloudfuji::User.pending_invites()
    end
  end

  describe "remove" do
    it "should post_command to remove_unity_url with ido_id in params" do
      params = {:ido_id => "some_random_ido_id"}
      Cloudfuji::Command.should_receive(:post_command).with(Cloudfuji::Base.remove_unity_url, params)
      Cloudfuji::User.remove(params[:ido_id])
    end
  end

end
