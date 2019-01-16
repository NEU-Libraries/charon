class GenericUploadsController < ApplicationController
  before_action :set_generic_upload, only: [:show, :edit, :update, :destroy]

  # GET /generic_uploads
  # GET /generic_uploads.json
  def index
    @generic_uploads = GenericUpload.all
  end

  # GET /generic_uploads/1
  # GET /generic_uploads/1.json
  def show
  end

  # GET /generic_uploads/new
  def new
    @generic_upload = GenericUpload.new
  end

  # GET /generic_uploads/1/edit
  def edit
  end

  # POST /generic_uploads
  # POST /generic_uploads.json
  def create
    @generic_upload = GenericUpload.new(generic_upload_params)

    respond_to do |format|
      if @generic_upload.save
        format.html { redirect_to @generic_upload, notice: 'Generic upload was successfully created.' }
        format.json { render :show, status: :created, location: @generic_upload }
      else
        format.html { render :new }
        format.json { render json: @generic_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /generic_uploads/1
  # PATCH/PUT /generic_uploads/1.json
  def update
    respond_to do |format|
      if @generic_upload.update(generic_upload_params)
        format.html { redirect_to @generic_upload, notice: 'Generic upload was successfully updated.' }
        format.json { render :show, status: :ok, location: @generic_upload }
      else
        format.html { render :edit }
        format.json { render json: @generic_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /generic_uploads/1
  # DELETE /generic_uploads/1.json
  def destroy
    @generic_upload.destroy
    respond_to do |format|
      format.html { redirect_to generic_uploads_url, notice: 'Generic upload was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_generic_upload
      @generic_upload = GenericUpload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def generic_upload_params
      params.require(:generic_upload).permit(:generics)
    end
end
