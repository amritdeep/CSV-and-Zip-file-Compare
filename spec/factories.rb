require 'faker'

FactoryGirl.define do

	factory :batch do
		name "Batch 1"
		# zipfile File.open('spec/support/archive.zip')
		# csvfile File.open('spec/support/example11.csv')
		zipfile { fixture_file_upload(Rails.root.join('spec', 'support', 'archive.zip'), 'application/zip')}
		csvfile { fixture_file_upload(Rails.root.join('spec', 'support', 'example.csv'), 'text/csv')}
	end

	factory :record do
		batch { |b| b.association(:batch) }
	end
	
end	