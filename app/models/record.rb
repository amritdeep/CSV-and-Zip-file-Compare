class Record < ActiveRecord::Base
  belongs_to :batch

	has_attached_file :pdf, 
					  default_url: ":attachment/:id/:style.:extension",
					:s3_domain_url => "******.s3.amazonaws.com",
	            :storage => :s3,
	            :s3_credentials => Rails.root.join("config/aws.yml"),
	            :bucket => 'keystone-development',
	            # :s3_permissions => :public_read,
	            :s3_permissions => :private,
	            :s3_protocol => "http",
	            :convert_options => { :all => "-auto-orient" },
	            :encode => 'utf8'

	validates_attachment :pdf, #presence: true,
	:content_type => { content_type: 'application/pdf' }
	
end
