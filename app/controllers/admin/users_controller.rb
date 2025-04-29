class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
    if params[:query].present?
      query = "%#{params[:query]}%"
      @users = @users.where(
        "first_name ILIKE :query OR last_name ILIKE :query OR company ILIKE :query OR email ILIKE :query",
        query: query
      )
    end
    @users = @users.sort_by(&:first_name)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        Product.all.each { |p| @user.price_list_items.create!(product: p, price: p.price) }

        format.html { redirect_to admin_users_url, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: admin_user_url(@user) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        if user_params[:price_list_items_attributes]
          format.html { redirect_to admin_user_price_list_items_url(@user), notice: "Price list items were successfully updated." }
        else
          format.html { redirect_to edit_admin_user_url(@user), notice: "User was successfully updated." }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params
        .require(:user)
        .permit(
          :first_name,
          :last_name,
          :company,
          :email,
          :role,
          price_list_items_attributes: [
            :id,
            :price,
            :hidden,
          ]
        )
    end
end
