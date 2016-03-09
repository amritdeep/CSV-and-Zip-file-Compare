class RecordController < ApplicationController
  def show
  	@dataset = Dataset.find(params[:dataset_id])
  	@record = Record.find(params[:id])
  	send_data(@record.pdf_file_name)
  	# binding.pry
  end
end
