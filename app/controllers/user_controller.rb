class UserController < ApplicationController
  def new
  end

  def create
  	@user = User.new(user_params)
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
