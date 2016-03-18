class Record < ActiveRecord::Base
	belongs_to :batch

	validates :name, presence: true
	validates :pid, presence: true


	has_attached_file :pdf, 
		url: ":s3_domain_url",
		path: ':class/:attachment/:id_partition/:style/:filename',
		storage: :s3,
		bucket: ENV['S3_BUCKET'],
    	s3_permissions: :private,
    	s3_protocol: "https"

	validates_attachment :pdf, #presence: true,
	content_type: { content_type: 'application/pdf' }
	
end
