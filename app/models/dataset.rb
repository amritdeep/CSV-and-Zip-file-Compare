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

    before_save :parse_file
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

	  def parse_pdf
	  	zipfile_file_name = zipfile.instance.zipfile_file_name
	  	copy_file =  zipfile.copy_to_local_file(:original, "tmp/#{zipfile_file_name}")
	  	local_zip_file = "tmp/#{zipfile_file_name}"
	  	folder_name = zipfile_file_name.split('.').first

	  	Zip::File.open(local_zip_file) do |zip|
	  		zip.each do |entry|
	  			puts "Extracting #{entry.name}"
	  			zip_file_path = "tmp/#{folder_name}/#{entry.name}"
	  			entry.extract(zip_file_path)
		  		self.records.each do |record|
		  			if entry.name.include?record.data[:ajb_corp_dbp]
			  			file = File.open(zip_file_path)
			  			record.pdf = file
			  			file.close
			  			record.save!
		  			end
		  		end
	  		end
	  	end
	  	
	  end


end
