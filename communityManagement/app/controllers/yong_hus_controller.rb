class YongHusController < ApplicationController
  before_action :set_yong_hu, only: [:edit, :destroy]

  # GET /yong_hus
  # GET /yong_hus.json
  def index
    @yong_hus = YongHu.all
  end

  # GET /yong_hus/1
  # GET /yong_hus/1.json
  def show
    @yong_hu = YongHu.find_by(user_id: current_user.user_id)
    if @yong_hu == nil
      #redirect_to :action => "edit", :user_id => current_user.user_id
      #redirect_to :action => "new"
      redirect_to new_yong_hu_path
    else
      session[:yong_hu_id] = @yong_hu.id
    end
  end

  # GET /yong_hus/new
  def new
    @yong_hu = YongHu.new
  end

  # GET /yong_hus/1/edit
  def edit
  end

  # POST /yong_hus
  # POST /yong_hus.json
  def create
    @yong_hu = YongHu.new(yong_hu_params)

    respond_to do |format|
      if @yong_hu.save
        session[:yong_hu_id] = @yong_hu.id
        format.html { redirect_to @yong_hu, notice: 'Yong hu was successfully created.' }
        format.json { render :show, status: :created, location: @yong_hu }
      else
        format.html { render :new }
        format.json { render json: @yong_hu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /yong_hus/1
  # PATCH/PUT /yong_hus/1.json
  def update
    @yong_hu = YongHu.find_by(params[:user_id])
    if @yong_hu.present?
      respond_to do |format|
        if @yong_hu.update(yong_hu_params)
          format.html { redirect_to @yong_hu, notice: 'Yong hu was successfully updated.' }
          format.json { render :show, status: :ok, location: @yong_hu }
        else
          format.html { render :edit }
          format.json { render json: @yong_hu.errors, status: :unprocessable_entity }
        end
      end
    else
      # redirect_to :action => "create"
      @yong_hu = YongHu.new(yong_hu_params)
      if @yong_hu.save
        redirect_to 'show'
      else
        render 'edit'
      end
    end

  end

  # DELETE /yong_hus/1
  # DELETE /yong_hus/1.json
  def destroy
    @yong_hu.destroy
    respond_to do |format|
      format.html { redirect_to yong_hus_url, notice: 'Yong hu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_yong_hu
      @yong_hu = YongHu.find_by(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def yong_hu_params
      params.require(:yong_hu).permit(:user_id, :real_name, :sex, :phone, :birth)
    end
end
