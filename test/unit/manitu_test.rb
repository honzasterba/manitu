require File.dirname(__FILE__) + '/../test_helper'

class ManituTest < Test::Unit::TestCase
  fixtures :sites, :checks
  
  def setup
    @site = sites(:jansterba)
  end
  
  def test_daemon
    Manitu.daemon
  end
  
  def test_check_site
    setup_200
    Manitu.check_site(@site)
  end
  
  def test_check_site_failed
    setup_500
    Manitu.check_site(@site)
  end
  
  protected
  
    def setup_200
      Manitu::Common.returns Net::HTTPSuccess.new("1", 200, "OK")    
    end
    
    def setup_500
      Manitu::Common.returns Net::HTTPServerError.new("1", 500, "OK")    
    end
    
    def setup_error
      Manitu::Common.raises Net::HTTPError    
    end

end
