defprotocol ICalendar.Value do
  @fallback_to_any true
  def to_ics(data)
end

alias ICalendar.Value


defimpl Value, for: BitString do
  def to_ics(x) do
    x
    |> String.replace(~S"\n", ~S"\\n")
    |> String.replace("\n", ~S"\n")
  end
end

defimpl Value, for: Tuple do
  defmacro elem2(x, i1, i2) do
    quote do
      unquote(x) |> elem(unquote(i1)) |> elem(unquote(i2))
    end
  end

  defmacro is_datetime_tuple(x) do
    quote do
      # Year
      ( unquote(x) |> elem2(0, 0)  |> is_integer) and
      # Month
      ( unquote(x) |> elem2(0, 1)  |> is_integer) and
      ((unquote(x) |> elem2(0, 1)) <= 12) and
      ((unquote(x) |> elem2(0, 1)) >= 1) and
      # Day
      ( unquote(x) |> elem2(0, 2)  |> is_integer) and
      ((unquote(x) |> elem2(0, 2)) <= 31) and
      ((unquote(x) |> elem2(0, 2)) >= 1) and
      # Hour
      ( unquote(x) |> elem2(1, 0)  |> is_integer) and
      ((unquote(x) |> elem2(1, 0)) <= 23) and
      ((unquote(x) |> elem2(1, 0)) >= 0) and
      # Minute
      ( unquote(x) |> elem2(1, 1)  |> is_integer) and
      ((unquote(x) |> elem2(1, 1)) <= 59) and
      ((unquote(x) |> elem2(1, 1)) >= 0) and
      # Second
      ( unquote(x) |> elem2(1, 2)  |> is_integer) and
      ((unquote(x) |> elem2(1, 2)) <= 60) and
      ((unquote(x) |> elem2(1, 2)) >= 0)
    end
  end


  def to_ics({{yy, mm, dd}, {h, m, s}} = x) when is_datetime_tuple(x) do
    import String, only: [rjust: 3]
    year  = yy |> to_string |> rjust(4, ?0)
    month = mm |> to_string |> rjust(2, ?0)
    day   = dd |> to_string |> rjust(2, ?0)
    hour  = h  |> to_string |> rjust(2, ?0)
    min   = m  |> to_string |> rjust(2, ?0)
    sec   = s  |> to_string |> rjust(2, ?0)
    year <> month <> day <> "T" <> hour <> min <> sec <> "Z"
  end

  def to_ics(x), do: x
end


defimpl Value, for: Any do
  def to_ics(x), do: x
end
