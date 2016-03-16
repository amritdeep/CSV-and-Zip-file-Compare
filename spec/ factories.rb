require 'faker'

FactoryGirl.define do

	factory :batch do
		name "Batch 1"
		csvfile File.open('spec/support/example.csv')
		zipfile File.open('spec/support/Archive.zip')
		# zipfile { fixture_file_upload(Rails.root.join('spec', 'support', 'Archive.zip'), 'application/zip')}
	end
	
end	