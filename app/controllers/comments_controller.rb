class CommentsController < ApplicationController
  def create
    if current_user.comments.create(comment_params)
      redirect_to 'static_pages#top'
    else
      render 'static_pages/top'
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy!
    redirect_to 'static_pages#top'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
