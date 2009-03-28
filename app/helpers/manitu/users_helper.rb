module Manitu::UsersHelper
  
  def rights_desc(rights)
    case rights
      
      when Right::READ
        "čtení"
      
      when Right::WRITE
        "úpravy"
      
      when Right::ADMIN
        "administrátor"
 
      else
        "CHYBA"
    end
  end
end
