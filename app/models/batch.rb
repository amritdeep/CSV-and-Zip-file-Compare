class  Batch < ActiveRecord::Base
	belongs_to :user
	has_many :records, :dependent => :destroy
	validates_presence_of :batch

	## CSV File
  	has_attached_file :file,
  		:url => "/attachments/:id/:style/:basename.:extension",
        :path => ":rails_root/public/attachments/:id/:style/:basename.:extension"

  	validates_attachment :file, presence: true,
    :content_type => { content_type: 'text/csv' }

    ## Zip File
  	has_attached_file :zipfile,
  	 	:url => "/attachments/:id/:style/:basename.:extension",
        :path => ":rails_root/public/attachments/:id/:style/:basename.:extension"
                   
  	validates_attachment :zipfile, presence: true,
    :content_type => { content_type: 'application/zip' }

    before_save :parse_file
    after_save :parse_pdf, :match_records_and_pdfs

    ##
    # What does the method do
    # @param String This argument is this
    # @return Boolean Does this
	def parse_file
	data = SmarterCSV.process(file.path)
		data.each { |hash| self.records.create(name: hash[:name], pid: hash[:pid])}
	end


	def parse_pdf
		zipfile_file_name = zipfile.instance.zipfile_file_name
		copy_file =  zipfile.copy_to_local_file(:original, "tmp/#{zipfile_file_name}")
		local_zip_file = "tmp/#{zipfile_file_name}"

		folder_name = zipfile_file_name.split('.').first
		unzip_file(local_zip_file, folder_name)

		# upload_to_s3(folder_name)
		# remove_unwanted_files(local_zip_file, folder_name)
	end

	def working_dir
		"tmp/datasets/#{id}/pdfs"
	end

	## Unzip the file
	def unzip_file(file_name, folder)
		Zip::File.open(file_name) do |zip|
			zip.each { |entry| entry.extract("#{working_dir}/#{entry.name}") { true } }
		end		  	
	end

	## Uploading to S3 Server
	# def upload_to_s3
		# folder = folder_name.gsub("_", " ")
		# files = Dir.glob("#{working_dir}/#{folder}/*")
		# store_pdf_file(files)
	# end

	def tmp_filenames
		Dir.glob("#{working_dir}/*")
	end

	def match_records_and_pdfs
		records.each do |record|
			tmp_filenames.each do |file_path|
				# if filename.scan(/#{record.name}/i)
				record.update(pdf_file: File.open(file_path))
			end
		end
	end

	## Store pdf files for record
	def store_pdf_file(files)
		records.each do |record|
	  	files.each do |file|
	  		if file.split('-').last.include?(record.data[:name]) #|| record.data[:ajb_corp_dbp].include?file.split('-').last
		  		f = File.open(file)
		  		record.pdf = f
		  		f.close
		  		record.save!
	  		end
	  	end
		end	  	
	end

	## Removing File from Tmp Folder
	def remove_unwanted_files
		FileUtils.rm_rf(working_dir)
	end	  

end
