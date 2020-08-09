class CommentsController < ApplicationController
  def create
    @comments = Comment.all
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to root_path, success: '成功'
    else
      current_user.zap! if @comment.sentiment == :negative
      flash.now[:error] = '失敗'
      render 'static_pages/top'
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy!
    redirect_to root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
