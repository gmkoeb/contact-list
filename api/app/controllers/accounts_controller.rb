class AccountsController < ApplicationController
  before_action :authenticate_user
  def destroy
    password = params.require(:user).permit(:password)['password']

    if @current_user.valid_password?(password)
      @current_user.destroy
      render status: :ok, json: { message: 'Account deleted with success' }
    else
      render status: :unprocessable_content, json: { message: 'Wrong password. Try again' }
    end
  end
end