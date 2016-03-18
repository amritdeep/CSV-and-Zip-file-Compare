require 'rails_helper'

RSpec.describe RecordController, :type => :controller do
	describe "anonymous user" do
	    before :each do
	      # This simulates an anonymous user
	      login_with nil
	    end

	    it "should be redirected to signin" do
	      get :index
	      expect( response ).to redirect_to( new_user_session_path )
	    end
	end

	describe "Authenticate User" do

		let!(:user){ create(:user) }

		before :each do
			login_with user
		end
		
	end
end