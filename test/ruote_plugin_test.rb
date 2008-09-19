
require 'test/unit'

require 'rubygems'
require 'action_controller'
require 'action_controller/cgi_ext'
require 'action_controller/test_process'

require 'misc'


class RuotePluginTest < Test::Unit::TestCase

  def test__href

    request = ActionController::TestRequest.new
    hrefm = RuotePlugin.href_method(request)

    assert_equal(
      'http://test.host/processes/2008-zygo',
      hrefm.call(:processes, "2008-zygo"))
  end
end

