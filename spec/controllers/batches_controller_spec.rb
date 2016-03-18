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

		let!(:user) 				{ create(:user) }

		before :each do
			login_with user
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
			get :new
			expect(response).to be_success
		end

		xit "should show all the batches" do
			# batch = build(:batch)
			batch = create(:batch)
			get :show, { id: batch.id, user_id: my_cool_user.id }
			# binding.pry
		end

		it "should run batch with data" do
			batch = create(:batch, user_id: user.id)
			post :create, format: :html, batch: { name: batch.name, csvfile: fixture_file_upload('example.csv', 'text/csv'), zipfile: fixture_file_upload('archive.zip', 'application/zip')}

			expect(user.id).to eql(user.id)
			expect(user.batches.count).to eql(2)
			expect(user.batches.first.csvfile_file_name).to eql("example.csv")
			expect(user.batches.first.zipfile_file_name).to eql("archive.zip")
		end

	end


end