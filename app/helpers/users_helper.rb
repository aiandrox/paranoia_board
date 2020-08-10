module UsersHelper
  def pc_name(user)
    "#{user.first_name}-#{user.clearance}-#{user.sector}"
  end
end
