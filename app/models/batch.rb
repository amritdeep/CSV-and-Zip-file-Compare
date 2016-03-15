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
    after_save :parse_pdf, :get_pdf_files, :remove_folder

    def working_dir
    	"tmp/keystone/"
    end

    def extract_dir
      	@folder_name = zipfile_file_name.split('.').first
    	"#{working_dir}#{@folder_name}/"  	
    end

	def parse_csv_file
		tempfile = csvfile.queued_for_write[:original].read
		@cp_csv_file = csvfile.instance.csvfile_file_name
		File.open("#{working_dir}#{@cp_csv_file}", 'w') {|f| f.write(tempfile) }
		data = SmarterCSV.process("#{working_dir}#{@cp_csv_file}")
		data.each { |hash| self.records.build(name: hash[:name], pid: hash[:pid])}
	end

	def parse_pdf
		@zipfile_file_name = zipfile.instance.zipfile_file_name
		copy_zip_file =  zipfile.copy_to_local_file(:original, "#{working_dir}#{@zipfile_file_name}")
		local_zip_file = "#{working_dir}#{@zipfile_file_name}"
		unzip_file(local_zip_file)
	end

	## 
	# Unzip the file
	# @param File name and Folder name
	def unzip_file(file_name)
		Zip::File.open(file_name) do |zip|
			zip.each { |entry| entry.extract("#{extract_dir}/#{entry.name}") { true } }
		end		  	
	end


	## Getting the Pdf files from Local Directory
	def get_pdf_files
		folder = @folder_name.gsub("_", " ")
		folder_name = extract_dir + "#{folder}"
		files = Dir.glob("#{folder_name}/*")
		store_pdf_file(files)
	end

	## Store pdf files for record
	def store_pdf_file(files)
		self.records.each do |record|
		  	files.each do |file|
		  		if file.split('-').last.include?record.name #|| record.data[:ajb_corp_dbp].include?file.split('-').last
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
		FileUtils.rm_rf("#{extract_dir}")
		FileUtils.rm_rf("#{working_dir}#{@cp_csv_file}")
		FileUtils.rm_rf("#{working_dir}#{@zipfile_file_name}")	  	
	end	  

end
