module ApiHelper
  def under_rate_limit?(user)
    # We will need to add 2 attributes to users: access_count, access_start
    # Suppose our rate limit is 100 accesses per minute
    # When an access is made:

    # if (current_time - user.access_start) > minute
    #   user.access_start = current_time
    #   user.access_count = 1
    #   return true
    # else
    #   if access_count <= 100
    #     access_count += 1
    #     return true
    #   else
    #     return false
    #   end
    # end
  end
end