require 'rails_helper'

RSpec.describe Batch, type: :model do

	# let!(:batch) { create(:batch) }
	## Validation
	# it { should validate_presence_of(:name) }
	it "should validate the present of name" do
		binding.pry
		
		batch = Batch.create(name: "Batch 1")
	end

end