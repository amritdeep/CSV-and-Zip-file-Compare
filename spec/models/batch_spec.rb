require 'rails_helper'

RSpec.describe Batch, type: :model do

	let(:batch) { create(:batch) }
	let(:record) { create(:batch) }
	
	# Validation
	it { should validate_presence_of(:name) }
	it { should have_many(:records) }
	
	# it "should be able to create records from the csv" do
	# 	# batch
	# 	binding.pry
	# 	# expect(batch.records.count).to eq(3)
	# 	# expect(batch.valid?).to eq(true)
	# end

end
