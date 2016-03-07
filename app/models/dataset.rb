class Dataset < ActiveRecord::Base
	has_many :records, :dependent => :destroy

  	has_attached_file :file
  	validates_attachment :file, presence: true,
    :content_type => { content_type: 'text/csv' }

    before_save :parse_file

	  def parse_file
	    tempfile = file.queued_for_write[:original].read
	    my_csv = CSV.new(tempfile, :headers => true,
	                               :header_converters => :symbol,
	                               :converters => :all)
	    my_array_of_hashes = my_csv.to_a.map {|row| row.to_hash}
	    
	    my_array_of_hashes.each do |hash|
	      record = self.records.build
	      record.data = hash
	      record.save
	    end
	  end
end
