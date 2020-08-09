class MypagesController < ApplicationController
  def show
    @comments = current_user.comments.desc
  end

  def update
    if current_user.create_citizen
      flash[:success] = '新しい市民を生成しました'
    else
      flash[:error] = current_user.errors.full_messages.first
    end
    redirect_to mypage_path
  end

  def first_name # update
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
