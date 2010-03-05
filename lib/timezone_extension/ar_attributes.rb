# ActiveRecord override
module TimezoneConverter
  private
  def instantiate_time_object(name, values)
    if self.class.send(:create_time_zone_conversion_attribute?, name, column_for_attribute(name))
      if values.size == 7
        hour,min = values.pop.divmod 100
        ofs = hour * 60 + min
        # to set collect time zone:
        #  1) create UTC DateTime
        #  2) convert to Time
        #  3) set time zone in default configuration.
        (DateTime.new(*values) + Rational(-ofs, 24 * 60)).to_time.in_time_zone(Time.zone)
      else
        Time.zone.local(*values)
      end
    else
      Time.time_with_datetime_fallback(@@default_timezone, *values)
    end
  end
end
