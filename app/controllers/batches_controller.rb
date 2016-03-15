class BatchesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_batch, only: [:edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    # @batchs = Dataset.all
    @batchs = Batch.all
  end


  def show
    @batch = current_user.batches.find(params[:id])
  end

  # GET /datasets/new
  def new
    @batch = Batch.new
    # @batch = current_user.datasets.new
  end

  # GET /datasets/1/edit
  def edit
  end

  def create
    # @batch = Dataset.new(dataset_params)
    @batch = current_user.batches.new(batch_params)

    respond_to do |format|
      if @batch.save
        format.html { redirect_to @batch, notice: 'Batch was successfully created.' }
        format.json { render :show, status: :created, location: @batch }
        format.js   { render :show, status: :created, location: @batch }
      else
        format.html { render :new }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /datasets/1
  # PATCH/PUT /datasets/1.json
  def update
    respond_to do |format|
      if @batch.update(batch_params)
        format.html { redirect_to @batch, notice: 'Batch was successfully updated.' }
        format.json { render :show, status: :ok, location: @batch }
      else
        format.html { render :edit }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @batch.destroy
    respond_to do |format|
      format.html { redirect_to datasets_url, notice: 'Batch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      # @batch = Batch.find(params[:id])
      @batch = current_user.batches.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def batch_params
      params.require(:batch).permit(:name, :file, :zipfile)
    end
end
