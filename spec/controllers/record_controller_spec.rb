require 'rails_helper'

RSpec.describe RecordController, :type => :controller do

	describe "Authenticate User" do

		let!(:user){ create(:user) }

		before :each do
			login_with user
		end

		it "should able to show data" do
			batch = create(:batch, user_id: user.id)
			get :show, id: batch.records.first.id, batch_id: batch.id
			expect(response).to be_success
		end



	end
end