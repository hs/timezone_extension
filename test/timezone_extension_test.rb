require 'test_helper'
$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'

class TimezoneExtensionTest < ActionView::TestCase
  def test_select_timezone
    expected = %(<select id="date_timezone" name="date[timezone]">\n)
    expected << %(<option value="-1100">(GMT-1100) BST</option>\n<option value="-1000">(GMT-1000) HST</option>\n<option value="-0900">(GMT-0900) PST</option>\n<option value="-0800">(GMT-0800) PST</option>\n<option value="-0700">(GMT-0700) MST</option>\n<option value="-0700">(GMT-0700) CST</option>\n<option value="-0700">(GMT-0700) PST</option>\n<option value="-0600">(GMT-0600) CST</option>\n<option value="-0500">(GMT-0500) COT</option>\n<option value="-0500">(GMT-0500) EST</option>\n<option value="-0500">(GMT-0500) PET</option>\n<option value="-0430">(GMT-0430) VET</option>\n<option value="-0400">(GMT-0400) AST</option>\n<option value="-0400">(GMT-0400) BOT</option>\n<option value="-0400">(GMT-0400) CLST</option>\n<option value="-0330">(GMT-0330) NST</option>\n<option value="-0300">(GMT-0300) BRT</option>\n<option value="-0300">(GMT-0300) ART</option>\n<option value="-0300">(GMT-0300) WGT</option>\n<option value="-0200">(GMT-0200) GST</option>\n<option value="-0100">(GMT-0100) AZOT</option>\n<option value="-0100">(GMT-0100) CVT</option>\n<option value="+0000">(GMT+0000) WET</option>\n<option value="+0000">(GMT+0000) IST</option>\n<option value="+0000">(GMT+0000) CET</option>\n<option value="+0000">(GMT+0000) BST</option>\n<option value="+0000">(GMT+0000) LRT</option>\n<option value="+0000">(GMT+0000) UTC</option>\n<option value="+0100">(GMT+0100) CET</option>\n<option value="+0100">(GMT+0100) WET</option>\n<option value="+0200">(GMT+0200) EET</option>\n<option value="+0200">(GMT+0200) CAT</option>\n<option value="+0200">(GMT+0200) IST</option>\n<option value="+0200">(GMT+0200) MSK</option>\n<option value="+0200">(GMT+0200) SAST</option>\n<option value="+0300">(GMT+0300) AST</option>\n<option value="+0300">(GMT+0300) MSK</option>\n<option value="+0300">(GMT+0300) EAT</option>\n<option value="+0330">(GMT+0330) IRST</option>\n<option value="+0400">(GMT+0400) GST</option>\n<option value="+0400">(GMT+0400) BAKT</option>\n<option value="+0400">(GMT+0400) TBIT</option>\n<option value="+0400">(GMT+0400) YERT</option>\n<option value="+0430">(GMT+0430) AFT</option>\n<option value="+0500">(GMT+0500) SVET</option>\n<option value="+0500">(GMT+0500) KART</option>\n<option value="+0500">(GMT+0500) TAST</option>\n<option value="+0530">(GMT+0530) IST</option>\n<option value="+0545">(GMT+0545) IST</option>\n<option value="+0600">(GMT+0600) ALMT</option>\n<option value="+0600">(GMT+0600) DACT</option>\n<option value="+0600">(GMT+0600) NOVT</option>\n<option value="+0630">(GMT+0630) MMT</option>\n<option value="+0700">(GMT+0700) ICT</option>\n<option value="+0700">(GMT+0700) WIT</option>\n<option value="+0700">(GMT+0700) KRAT</option>\n<option value="+0800">(GMT+0800) CST</option>\n<option value="+0800">(GMT+0800) LONT</option>\n<option value="+0800">(GMT+0800) HKT</option>\n<option value="+0800">(GMT+0800) IRKT</option>\n<option value="+0800">(GMT+0800) MALT</option>\n<option value="+0800">(GMT+0800) WST</option>\n<option value="+0800">(GMT+0800) SGT</option>\n<option value="+0800">(GMT+0800) ULAT</option>\n<option value="+0800">(GMT+0800) URUT</option>\n<option selected="selected" value="+0900">(GMT+0900) JST</option>\n<option value="+0900">(GMT+0900) KST</option>\n<option value="+0900">(GMT+0900) YAKT</option>\n<option value="+0930">(GMT+0930) CST</option>\n<option value="+1000">(GMT+1000) EST</option>\n<option value="+1000">(GMT+1000) GST</option>\n<option value="+1000">(GMT+1000) PGT</option>\n<option value="+1000">(GMT+1000) VLAT</option>\n<option value="+1100">(GMT+1100) MAGT</option>\n<option value="+1100">(GMT+1100) NCT</option>\n<option value="+1200">(GMT+1200) NZST</option>\n<option value="+1200">(GMT+1200) FJT</option>\n<option value="+1200">(GMT+1200) PETT</option>\n<option value="+1200">(GMT+1200) MHT</option>\n<option value="+1300">(GMT+1300) TOT</option>\n)
    expected << %(</select>)


    [ 'UTC', 'Tokyo' ].each do |tz|
      Time.zone = tz
      assert_dom_not_equal expected, select_timezone if tz == 'UTC'
      assert_dom_equal expected, select_timezone if tz == 'Tokyo'
      assert_dom_equal expected, select_timezone({:timezone => 'JST'})
    end
  end

  def test_controller_methods
    # get_multiparameter_attributes
    input1 = {
      "test(1i)" => "10", "test(2)" => "string", "test(3f)" => "3.14", "test(4i)" => "3.14",
      "test(5i)" => "g", "test(6f)" => "g", "test(7i)" => "1g", "test(8f)" => "3.14g"
    }
    expected1 = [ 10, "string", 3.14, 3, 0, 0, 1, 3.14 ]

    # get_multiparameter_time
    input2 = { "test(1i)" => "2010", "test(2i)" => "1", "test(3i)" => "1",
      "test(4i)" => "0", "test(5i)" => "0", "test(6i)" => "0", "test(7i)" => "+0000" }
    input3 = { "test(1i)" => "2010", "test(2i)" => "1", "test(3i)" => "1",
      "test(4i)" => "9", "test(5i)" => "0", "test(6i)" => "0", "test(7i)" => "+0900" }
    input4 = { "test(1i)" => "2009", "test(2i)" => "12", "test(3i)" => "31",
      "test(4i)" => "23", "test(5i)" => "0", "test(6i)" => "0", "test(7i)" => "-0100" }
    expected2 = Time.gm(2010, 1, 1, 0, 0, 0)

    [ 'UTC', 'Tokyo' ].each do |tz|
      Time.zone = tz
      assert_equal expected1, ActionController::Base.new.get_multiparameter_attributes(input1, "test")
      assert_equal expected2, ActionController::Base.new.get_multiparameter_time(input2, "test")
      assert_equal expected2, ActionController::Base.new.get_multiparameter_time(input3, "test")
      assert_equal expected2, ActionController::Base.new.get_multiparameter_time(input4, "test")
    end
  end
end
