class RecordController < ApplicationController
  before_filter :authenticate_user!

  def show
  	@dataset = Dataset.find(params[:dataset_id])
  	@record = Record.find(params[:id])
  	data = open(@record.pdf.expiring_url)
  	send_data data.read, :type => data.content_type, :x_sendfile => true, :url_based_filename => true
  end

  def edit
  	@dataset = Dataset.find(params[:dataset_id])
  	@record = @dataset.records.find(params[:id])
  end

  def update
  	@dataset = Dataset.find(params[:dataset_id])
  	@record = @dataset.records.find(params[:id])
  	@record.pdf = params[:record][:pdf]

  	respond_to do |format|
  		if @record.save!
	        format.html { redirect_to @dataset, notice: 'Record was successfully updated.' }
	        format.json { render :show, status: :ok, location: @dataset }	
      	else
        	format.html { render :edit }
        	format.json { render json: @dataset.errors, status: :unprocessable_entity }	        
	  	end  		
  	end
  end



end
