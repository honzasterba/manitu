require File.dirname(__FILE__) + '/../test_helper'

class ConfirmerTest < Test::Unit::TestCase
  fixtures :sites, :checks
  
  def setup
    @site = sites(:jansterba)
    @confirmer = Manitu::Confirmer.new(@site)
  end

  def test_confirm_200
    Manitu::Common.returns Net::HTTPSuccess.new("1", 200, "OK")
    assert_nil @confirmer.confirm
    assert_saved @site
    assert_equal Site::STATE_CHECKING, @site.state
  end
  
  def test_confirm_500
    Manitu::Common.returns Net::HTTPServerError.new("1", 500, "OK")
    res = @confirmer.confirm
    assert_not_nil res
    assert_kind_of String, res
    assert_not_equal Site::STATE_CHECKING, @site.state
  end
  
  def test_confirm_error
    Manitu::Common.raises Net::HTTPError
    res = @confirmer.confirm
    assert_not_nil res
    assert_kind_of String, res
  end
end
