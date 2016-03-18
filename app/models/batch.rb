class Batch < ActiveRecord::Base
	has_many :records, dependent: :destroy
	belongs_to :user

	validates :name, presence: true

	## CSV File
  	has_attached_file :csvfile,
  		url: "/attachments/:id/:style/:basename.:extension",
        path: ":rails_root/public/attachments/:id/:style/:basename.:extension"

  	validates_attachment :csvfile, presence: true,
    content_type: { content_type: 'text/csv' }

    ## Zip File
  	has_attached_file :zipfile,
  	 	url: "/attachments/:id/:style/:basename.:extension",
        path: ":rails_root/public/attachments/:id/:style/:basename.:extension"
                   
  	validates_attachment :zipfile, presence: true,
    content_type: { content_type: 'application/zip' }

    after_create :process!

    private

    def process!
		parse_csv_file
		parse_pdf_file
		get_pdf_files
		remove_folder    	
    end

    def working_dir
    	"tmp/keystone/"
    end

    def extract_dir
		@zipfile_file_name = zipfile.instance.zipfile_file_name
      	@folder_name = zipfile_file_name.split('.').first
    	"#{working_dir}#{@folder_name}/"  	
    end

	def parse_csv_file
		data = SmarterCSV.process(csvfile.path)
		data.each { |hash| self.records.create(name: hash[:name], pid: hash[:pid])}
	end

	def parse_pdf_file
		file_name = File.open(zipfile.path)
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
		records.each do |record|
		  	files.each do |file|
		  		record.update(pdf: File.open(file)) if file.split('-').last.include?(record.name) 
		  	end
		end	  	
	end

	## Removing File from Tmp Folder
	def remove_folder  	
		FileUtils.rm_rf("#{extract_dir}")
	end	  

end
