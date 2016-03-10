require 'csv'
require 'rubygems'
require 'zip'
require 'fileutils'

class Dataset < ActiveRecord::Base
	has_many :records, :dependent => :destroy

	validates :dataset_name, presence: true
	validates :description, presence: true

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
	  	unzip_file(local_zip_file, folder_name)
	  	upload_to_s3(folder_name)
	  	remove_unwanted_files(local_zip_file, folder_name)
	  end

	  ## Unzip the file
	  def unzip_file(file_name, folder)
	  	Zip::File.open(file_name) do |zip|
	  		zip.each do |entry|
	  			puts "Extracting #{entry.name}"
	  			zip_file_path = "tmp/#{folder}/#{entry.name}"
	  			entry.extract(zip_file_path) { true }
	  		end
	  	end		  	
	  end

	  ## Uploading to S3 Server
	  def upload_to_s3(folder_name)
	  	folder = folder_name.gsub("_", " ")
	  	files = Dir.glob("tmp/#{folder_name}/#{folder}/*")
	  	store_pdf_file(files)
	  end

	  ## Store pdf files for record
	  def store_pdf_file(files)
	  	self.records.each do |record|
		  	files.each do |file|
		  		if file.split('-').last.include?record.data[:name] #|| record.data[:ajb_corp_dbp].include?file.split('-').last
			  		f = File.open(file)
			  		record.pdf = f
			  		f.close
			  		record.save!
		  		end
		  	end
	  	end	  	
	  end
	  
	  ## Removing File from Tmp Folder
	  def remove_unwanted_files(files, folder)
	  	FileUtils.rm_rf("#{files}")
	  	FileUtils.rm_rf(Dir.glob("tmp/#{folder}"))	  	
	  end	  

end
