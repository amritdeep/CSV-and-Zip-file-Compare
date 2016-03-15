class RecordController < ApplicationController
  before_filter :authenticate_user!

  def show
  	@batch = Dataset.find(params[:dataset_id])
  	@record = Record.find(params[:id])
  	data = open(@record.pdf.expiring_url)
  	send_data data.read, :type => data.content_type, :x_sendfile => true, :url_based_filename => true
  end

  def edit
  	@batch = Dataset.find(params[:dataset_id])
  	@record = @batch.records.find(params[:id])
  end

  def update
  	@batch = Dataset.find(params[:dataset_id])
  	@record = @batch.records.find(params[:id])
  	@record.pdf = params[:record][:pdf]

  	respond_to do |format|
  		if @record.save!
	        format.html { redirect_to @batch, notice: 'Record was successfully updated.' }
	        format.json { render :show, status: :ok, location: @batch }	
      	else
        	format.html { render :edit }
        	format.json { render json: @batch.errors, status: :unprocessable_entity }	        
	  	end  		
  	end
  end



end
