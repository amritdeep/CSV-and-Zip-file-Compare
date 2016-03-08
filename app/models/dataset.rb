require 'csv'
require 'rubygems'
require 'zip'

class Dataset < ActiveRecord::Base
	has_many :records, :dependent => :destroy

  	has_attached_file :file
  	validates_attachment :file, presence: true,
    :content_type => { content_type: 'text/csv' }

  	has_attached_file :zipfile
  	validates_attachment :zipfile, presence: true,
    :content_type => { content_type: 'application/zip' }

    # before_save :parse_file #, :parse_zipfile
    after_save :parse_pdf

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

	  def parse_zipfile
	  	# binding.pry
	    # tempzipfile = zipfile.queued_for_write[:original].read
	    # tempzipfile = zipfile.queued_for_write[:original]
	  end

	  def parse_pdf
	  	zipfile_file_name = zipfile.instance.zipfile_file_name
	  	copy_file =  zipfile.copy_to_local_file(:original, "tmp/#{zipfile_file_name}")
	  	local_zip_file = "tmp/#{zipfile_file_name}"

	  	Zip::File.open(local_zip_file) do |zip|
	  		puts zip.count
	  		zip.each do |entry|
	  			binding.pry
		  		self.records.each do |record|
		  			puts record.id
	  			binding.pry
		  			
		  			puts record.data[]
		  		end


	  		end
	  		# self.records.each do |record|
	  		# 	puts record.id
	  		# 	puts record.data[]
	  		# end
	  	end
	  	
	  end


end
