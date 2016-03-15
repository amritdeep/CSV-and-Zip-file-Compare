class Batch < ActiveRecord::Base
	has_many :records, :dependent => :destroy
	belongs_to :user

	validates :name, presence: true

	## CSV File
  	has_attached_file :csvfile,
  		:url => "/attachments/:id/:style/:basename.:extension",
        :path => ":rails_root/public/attachments/:id/:style/:basename.:extension"

  	validates_attachment :csvfile, presence: true,
    :content_type => { content_type: 'text/csv' }

    ## Zip File
  	has_attached_file :zipfile,
  	 	:url => "/attachments/:id/:style/:basename.:extension",
        :path => ":rails_root/public/attachments/:id/:style/:basename.:extension"
                   
  	validates_attachment :zipfile, presence: true,
    :content_type => { content_type: 'application/zip' }

    before_save :parse_csv_file
    after_save :parse_pdf

    def working_dir
    	"tmp/keystone/"
    end

    def extract_dir
      	folder_name = zipfile_file_name.split('.').first
    	"#{working_dir}#{folder_name}"  	
    end

	def parse_csv_file
		tempfile = csvfile.queued_for_write[:original].read
		cp_csv_file = csvfile.instance.csvfile_file_name
		File.open("#{working_dir}#{cp_csv_file}", 'w') {|f| f.write(tempfile) }
		data = SmarterCSV.process("#{working_dir}tempfile.csv")
		# data.each { |hash| self.records.create(name: hash[:name], pid: hash[:pid])}
		data.each { |hash| self.records.build(name: hash[:name], pid: hash[:pid])}
	end

	def parse_pdf
		zipfile_file_name = zipfile.instance.zipfile_file_name
		copy_zip_file =  zipfile.copy_to_local_file(:original, "#{working_dir}#{zipfile_file_name}")
		local_zip_file = "#{working_dir}#{zipfile_file_name}"
		# folder_name = zipfile_file_name.split('.').first
		# binding.pry
		unzip_file(local_zip_file)
		# upload_to_s3(folder_name)
		# remove_unwanted_files(local_zip_file, folder_name)
		remove_folder
	end

	## 
	# Unzip the file
	# @param File name and Folder name
	def unzip_file(file_name)
		Zip::File.open(file_name) do |zip|
			zip.each { |entry| entry.extract("#{extract_dir}/#{entry.name}") { true } }
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
	def remove_folder
		# FileUtils.rm_rf("#{files}")
		# FileUtils.rm_rf(Dir.glob("tmp/#{folder}"))
		FileUtils.rm_rf("#{working_dir}")	  	
	end	  

end
