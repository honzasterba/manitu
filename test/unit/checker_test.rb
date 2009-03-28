require File.dirname(__FILE__) + '/../test_helper'

class CheckerTest < Test::Unit::TestCase
  fixtures :sites, :checks
  
  def setup
    @site = sites(:jansterba)
    @checker = Manitu::Checker.new(@site)
  end
  
  def test_run_check
    setup_200
    record = @checker.run_check(@site.system_check, @checker.create_record(@site.system_check))
    assert_saved record
    assert record.ok?
  end
  
  def test_run_check_on_error
    setup_error
    record = @checker.run_check(@site.system_check, @checker.create_record(@site.system_check))
    assert_saved record
    assert !record.ok?
  end
  
  def test_run_check_on_500
    setup_500
    record = @checker.run_check(@site.system_check, @checker.create_record(@site.system_check))
    assert_saved record
    assert !record.ok?
  end
  
  def test_user_checks
    setup_200
    assert @checker.user_checks
  end
  
  def test_system_check_ok
    setup_200
    assert @checker.system_check.ok?
    @site.system_check.active = false
    assert @site.system_check.save
    assert @checker.system_check.ok?
    setup_error
    assert !@checker.system_check.ok?
  end

  def test_run
    @checker.run
  end
  
  def test_sytem_check
    setup_200
    last_record = @site.system_check.last_record
    new_record = @checker.system_check
    @site.reload
    assert new_record
    assert @site.system_check.last_record
    assert_equal new_record.id, @site.system_check.last_record.id
    assert_saved new_record
    assert new_record.ok?
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
