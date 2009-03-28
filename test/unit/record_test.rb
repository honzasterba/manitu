require File.dirname(__FILE__) + '/../test_helper'

class RecordTest < Test::Unit::TestCase
  fixtures :records

  help_testing Record, :check_id => 1, :report_id => 1, :status => 0, :message => "OK"
  
  def test_default_vals
    rec = create_record :length => nil
    assert_equal 0, rec.status
    assert_equal 0, rec.length
    assert_equal nil, rec.body
  end
end
