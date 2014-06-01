require 'test_helper'

class ScheduleNotifierTest < ActionMailer::TestCase

  test "send daily schedule" do
    events = Event.where('DATE(start_time) = "2013-10-15"')
    group = Group.find(1)
    user = User.find(1)

    email = ScheduleNotifier.daily_schedule(events, group, user).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['no-reply@seatsha.re'], email.from
    assert_equal ['stonej@example.net'], email.to
    assert_equal 'Today\'s events for Geeks Watching Hockey', email.subject
    assert_includes email.body.to_s, '<title>Today&#39;s events for Geeks Watching Hockey</title>'
    assert_includes email.body.to_s, '<td><a href="http://localhost:3000/groups/1/event-7">Nashville Predators vs. Florida Panthers</a></td>'
  end

  test "send weekly schedule" do
    events = Event.where('start_time >= "2013-10-13" AND start_time <= "2013-10-20"').order('start_time ASC')
    group = Group.find(1)
    user = User.find(1)

    email = ScheduleNotifier.weekly_schedule(events, group, user).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['no-reply@seatsha.re'], email.from
    assert_equal ['stonej@example.net'], email.to
    assert_equal 'The week ahead for Geeks Watching Hockey', email.subject
    assert_includes email.body.to_s, '<title>The week ahead for Geeks Watching Hockey</title>'
    assert_includes email.body.to_s, '<td><a href="http://localhost:3000/groups/1/event-6">Nashville Predators vs. Los Angeles Kings</a></td>'
  end

end