require 'faker'

FactoryGirl.define do

	factory :batch do
		user { |u| u.association(:user) }
		name "Batch 1"
		# zipfile File.open('spec/support/archive_new.zip')
		# csvfile File.open('spec/support/example11.csv')

		zipfile { fixture_file_upload('spec/support/archive_new.zip', 'application/zip')}
		csvfile { fixture_file_upload('spec/support/example.csv', 'text/csv')}

		# zipfile { fixture_file_upload(Rails.root.join('spec', 'support', 'archive_new.zip'), 'application/zip')}
		# csvfile { fixture_file_upload(Rails.root.join('spec', 'support', 'example.csv'), 'text/csv')}
	end

	factory :record do
		batch { |b| b.association(:batch) }
	end

	factory :user do
	    email { Faker::Internet.email }
	    # email "user@keystone.com"
	    password "password"
	    password_confirmation "password"
	    # confirmed_at Date.today
	end
	
end	