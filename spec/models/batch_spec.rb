require 'rails_helper'

RSpec.describe Batch, type: :model do

	let(:user) { create(:user) }
	let(:batch) { create(:batch) }
	let(:record) { create(:record) }
	
	## Assocation
	it { should belong_to(:user) }
	it { should have_many(:records) }

	# Validation
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:csvfile) }
	it { should validate_presence_of(:zipfile) }

	it "should be able to create records from the csv" do
		expect(batch.records.count).to eq(3)
		expect(batch.valid?).to eq(true)
	end

	# it "should to extract zip file" do
	# 	extract_file_name = batch.records.first.pdf_file_name
	# 	csv_file_name = batch.records.first.name
	# end

end
