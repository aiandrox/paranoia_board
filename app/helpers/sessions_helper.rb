module SessionsHelper
  def remember(user)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:uuid] = user.uuid
  end

  def current_user
    if (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
    end
  end
end
