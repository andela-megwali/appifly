class UserController < ApplicationController
def index
  	@users = User.all
  end

  def new
  	@users = User.new
  end

  def create
  	@users = User.new(user_params)
    if @users.save
      redirect_to @users, notice: "User was successfully created."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  	if @users.update(user_params)
  		redirect_to @users, notice: "User was successfully updated."
  	else
  		render :edit
  	end
  end

  def destroy
  	@users.destroy
  	redirect_to users_url, notice: "User was successfully destroyed"
  end

  private
	# Use callbacks to share common setup or constraints between actions.
	def set_user
	  @user = User.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def user_params
	  params.require(:user).permit(:title, :firstname, :lastname, :username, :password, :email, :telephone, :subscription)
	end
end
