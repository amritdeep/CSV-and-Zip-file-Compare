require 'rails_helper'

RSpec.describe User, type: :model do

	## Assoication
	it { should have_many(:batches) }

	## Validation
	it { should validate_presence_of(:email) }
	it { should validate_presence_of(:password) }
	
end