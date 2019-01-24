class UsersController < ApplicationController
  def index
    @users = User.all
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name)
    end
end
