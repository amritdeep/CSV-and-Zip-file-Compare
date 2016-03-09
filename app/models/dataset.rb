require 'csv'
require 'rubygems'
require 'zip'
require 'fileutils'

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

	  	## Unzip the file
	  	Zip::File.open(local_zip_file) do |zip|
	  		zip.each do |entry|
	  			puts "Extracting #{entry.name}"
	  			zip_file_path = "tmp/#{folder_name}/#{entry.name}"
	  			entry.extract(zip_file_path) { true }
	  		end
	  	end

	  	## Uploading to S3 Server
	  	folder = folder_name.gsub("_", " ")
	  	files = Dir.glob("tmp/#{folder_name}/#{folder}/*")
	  	
	  	self.records.each do |record|
		  	files.each do |file|
		  		if file.split('-').last.include?record.data[:ajb_corp_dbp] #|| record.data[:ajb_corp_dbp].include?file.split('-').last
			  		f = File.open(file)
			  		record.pdf = f
			  		f.close
			  		record.save!
		  		end
		  	end
	  	end	

	  	## Removing File from Tmp Folder

	  	# files.each do |file|
	  	# 	f = File.open(file)
	  	# 	f.close
	  	# end

	  	# uploading_file_dir = "tmp/#{folder_name}/#{folder_name}"
	  	# deleting_folder = "tmp/#{folder_name}/_MACOSX"

	  	# # FileUtils.rm_rf("tmp/#{folder_name}/_MACOSX")
	  	# # FileUtils.rm_rf(Dir.glob("tmp/#{folder_name}/_MACOSX"))
	  	# Dir.entries(uploading_file_dir).select {|f| !File.directory? f}

	  	## Uploading in AWS
  			# FileUtils.rm_rf(zip_file_path) if zip_file_path.include?('__MACOSX')
	  		# self.records.each do |record|
	  		# 	# if entry.name.include?record.data[:ajb_corp_dbp]
	  		# 	# 	# sleep 1
		  	# 	# 	file = File.open(zip_file_path)
		  	# 	# 	record.pdf = file
		  	# 	# 	file.close
		  	# 	# 	record.save!
	  		# 	# end
	  		# end

	  end


end
