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

		it "should able to upload file with pdf file" do
			batch = create(:batch, user_id: user.id)
			patch :update, format: :html, id: batch.records.first.id, batch_id: batch.id, record: { pdf: fixture_file_upload('example.pdf', 'application/pdf')}

			expect(response).to redirect_to(batch_path(batch.id))
		end

		it "should not able to upload file without pdf file" do
			batch = create(:batch, user_id: user.id)
			patch :update, format: :html, id: batch.records.first.id, batch_id: batch.id, record: { pdf: fixture_file_upload('example.csv', 'text/csv')}
			expect(response).to render_template :edit
		end

		it "should able to edit record" do
			batch = create(:batch, user_id: user.id)
			get :edit, id: batch.records.first.id, batch_id: batch.id
			expect(response).to be_success
		end

	end
end