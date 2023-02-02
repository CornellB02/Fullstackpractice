class Api::SessionsController < ApplicationController
  def show
    if current_user
      @user = current_user
      render 'api/users/show'
    else
      render json: {user: nil }
    end
  end

  def create
    credentials = params.require(:username)
    password = params.require(:password)
    email = params.require(:email)

    # debugger
    @user = User.find_by_credentials(credentials, password)

    if @user
      login!(@user)
      render 'api/users/show'
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def destroy
    if current_user
      logout!
      render json: { message: "success!" }
    else
      render json: { message: "failure!" }
    end
  end

  private

  # def user_params
  #   debugger
  #   # params.require(:user).permit(:credential, :password)
  # end
end