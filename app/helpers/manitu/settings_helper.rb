module Manitu::SettingsHelper
  
  def rss_desc
    truncate(rss_path(:only_path => false, :id => act_user.token), 50)
  end
  
end
