defmodule ICalendar do
  @moduledoc """
  Generating ICalendars
  """

  defstruct events: []
  defdelegate to_ics(events), to: ICalendar.Serialize
end

defimpl ICalendar.Serialize, for: ICalendar do
  def to_ics(calendar) do
  events = Enum.map( calendar.events, &ICalendar.Serialize.to_ics/1 )
  """
  BEGIN:VCALENDAR
  CALSCALE:GREGORIAN
  VERSION:2.0
  X-WR-TIMEZONE:Europe/Amsterdam
  BEGIN:VTIMEZONE
  TZID:Europe/Amsterdam
  X-LIC-LOCATION:Europe/Amsterdam
  BEGIN:DAYLIGHT
  TZOFFSETFROM:+0100
  TZOFFSETTO:+0200
  TZNAME:CEST
  DTSTART:19700329T020000
  RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU
  END:DAYLIGHT
  BEGIN:STANDARD
  TZOFFSETFROM:+0200
  TZOFFSETTO:+0100
  TZNAME:CET
  DTSTART:19701025T030000
  RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU
  END:STANDARD
  END:VTIMEZONE
  #{events}END:VCALENDAR
  """
  end
end
