require 'rails_helper'

RSpec.describe RecordsController, :type => :controller do

	describe "Authenticate User" do

		let(:user)  		{ create(:user) }
		let!(:batch)		{ create(:batch, user: user) }
		let(:record)		{ batch.reload.records.first }

		before do
			login_with user
		end

		# it "should able to show data" do
		# 	get :show, id: record.id, batch_id: batch.id
		# 	expect(response).to be_success
		# end

		xit "should able to upload file with pdf file" do
			patch :update, format: :html, id: record.id, batch_id: batch.id, record: { pdf: fixture_file_upload('example.pdf', 'application/pdf')}
			expect(response).to redirect_to(batch_path(batch.id))
		end

		it "should not able to upload file without pdf file" do
			patch :update, format: :html, id: record.id, batch_id: batch.id, record: { pdf: fixture_file_upload('example.csv', 'text/csv')}
			expect(response).to render_template :edit
		end

		it "should able to edit record" do
			get :edit, id: record.id, batch_id: batch.id
			expect(response).to be_success
		end

	end
end
