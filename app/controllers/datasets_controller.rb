class DatasetsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_dataset, only: [:edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    @datasets = Dataset.all
  end


  def show
    @dataset = current_user.datasets.find(params[:id])
  end

  # GET /datasets/new
  def new
    @dataset = Dataset.new
    # @dataset = current_user.datasets.new
  end

  # GET /datasets/1/edit
  def edit
  end

  def create
    # sleep 1
    # @dataset = Dataset.new(dataset_params)
    @dataset = current_user.datasets.new(dataset_params)
  
    # if @dataset.save
    #   @dataset
    #   puts @dataset.inspect
    # else
    #  @dataset.errors.messages
    #   puts @dataset.inspect
       
    # end

    respond_to do |format|
      if @dataset.save
        format.html { redirect_to @dataset, notice: 'Dataset was successfully created.' }
        format.json { render :show, status: :created, location: @dataset }
        format.js   { render :show, status: :created, location: @dataset }
      else
        format.html { render :new }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /datasets/1
  # PATCH/PUT /datasets/1.json
  def update
    respond_to do |format|
      if @dataset.update(dataset_params)
        format.html { redirect_to @dataset, notice: 'Dataset was successfully updated.' }
        format.json { render :show, status: :ok, location: @dataset }
      else
        format.html { render :edit }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @dataset.destroy
    respond_to do |format|
      format.html { redirect_to datasets_url, notice: 'Dataset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dataset
      # @dataset = Dataset.find(params[:id])
      @dataset = current_user.datasets.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dataset_params
      params.require(:dataset).permit(:batch, :file, :zipfile)
    end
end
