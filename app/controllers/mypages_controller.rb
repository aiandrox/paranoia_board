class MypagesController < ApplicationController
  def show
    @comments = current_user.comments
  end

  def update
    @comments = current_user.comments
    if current_user.update(user_params)
      redirect_to mypage_path, success: '成功'
    else
      flash.now[:error] = '失敗'
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name)
  end
end
