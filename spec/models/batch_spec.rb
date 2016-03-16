require 'rails_helper'

RSpec.describe Batch, type: :model do

	# let(:batch) { create(:batch) }
	
	# Validation
	it { should validate_presence_of(:name) }
	
	# it "should validate the present of name" do
		# expect(batch.valid?).to eq(true)
	# end

end