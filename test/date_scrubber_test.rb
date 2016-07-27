require './test/test_helper'
require './lib/date_scrubber'

class DateScrubberTest < Minitest::Test

  def test_time_states_are_scrubbed
    test_time_1 = "2016-01-11 18:07:30 UTC"
    test_time_2 = "2012-03-27 14:54:33 UTC"
    test_time_3 = "2012-03-27 14:54:12 UTC"
    test_time_4 = "2016-01-11 09:34:06 UTC"
    test_time_5 = "2001-01-04 11:11:11 UTC"
    test_time_6 = "2001-01-04 01:01:01 UTC"
    test_time_10 = "2001-12-20 00:12:12 UTC"
    test_time_11 = "2001-12-20 00:00:00 UTC"
    test_time_7 = "2006-03-10"
    test_time_8 = "2003-11-16"
    test_time_9 = "2001-01-04"

    test_invalid_time_1 = "200-12-20 12:12:12 UTC"
    test_invalid_time_2 = "2002-12-20 25:12:12 UTC"
    test_invalid_time_3 = "2002-12-20 22:70:12 UTC"

    expected = ["2016-01-11", 18, 07, 30, "+00:00"]

    assert_equal expected, DateScrubber.scrub(test_time_1)
  end
end
