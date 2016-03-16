require 'rails_helper'

RSpec.describe BatchesController, :type => :controller do
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
		before :each do
			login_with :user
			# let(:batch) { create(:batch) }
			# let(:record) { create(:record) }
		end

		it "should allow to visit index page" do
			# login_with(:user)
			batch = create(:batch)
			get :index
			expect(response).to be_success
			expect(response).to render_template :index
			expect(assigns(:batchs)).to eq([batch])
		end

		it "should run/create batch" do
			# login_with(:user)

			get :new
			expect(response).to be_success
		end

		xit "should run batch with data" do
			batch = build(:batch)
			# binding.pry
			# post :create, { batch: batch }
			post :create, { name: batch.name, csvfile: batch.csvfile, zipfile: batch.zipfile }
		end


	end


end