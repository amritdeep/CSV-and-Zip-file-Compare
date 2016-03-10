class RecordController < ApplicationController
  
  def show
  	@dataset = Dataset.find(params[:dataset_id])
  	@record = Record.find(params[:id])
  	data = open(@record.pdf.expiring_url)
  	send_data data.read, :type => data.content_type, :x_sendfile => true, :url_based_filename => true
  end

end
