require 'rails_helper'

RSpec.describe Record, type: :model do
	
	let(:batch) { create(:batch) }
	let(:record) { create(:record) }

	## Association
	it { should belong_to(:batch) }

	## Validation
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:pid) }

end