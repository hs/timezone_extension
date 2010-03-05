# SelectDatetimeWithTimezone Controller methods.
module MultiparameterGetter
  def get_multiparameter_time(params, name)
    t = get_multiparameter_attributes(params, name)
    if t.size == 7
      hour,min = t.pop.divmod 100
#      ofs = hour * 60 + min
#      (DateTime.new(*t) + Rational(-ofs, 24 * 60)).to_time.in_time_zone(Time.zone)
      ofs = (hour * 60 + min) * 60
      (Time.utc(*t) - ofs).in_time_zone(Time.zone)
    else
      Time.zone.local(*t)
    end
  end

  def get_multiparameter_attributes(params, name)
    multi_parameters = []
    params.each do |k,v|
      multi_parameters << [ k, v ] if k =~ /^#{name}\(\d+[if]*\)/
    end
    multi_parameters.sort {
      |a,b| a[0].split(/\(/)[1].to_i <=> b[0].split(/\(/)[1].to_i
    }.collect {
      |e| e[0] =~ /\([0-9]*([if])\)/ ? e[1].send("to_" + $1) : e[1]
    }
  end
end
