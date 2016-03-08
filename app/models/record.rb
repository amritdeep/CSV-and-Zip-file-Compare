class Record < ActiveRecord::Base
  belongs_to :dataset
  serialize :data, Hash

  	has_attached_file :pdf
  	validates_attachment :pdf, presence: true,
    :content_type => { content_type: 'application/pdf' }
end
