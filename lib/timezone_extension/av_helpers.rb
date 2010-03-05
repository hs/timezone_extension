# SelectDatetimeWithTimezone Helpers
module ActionView::Helpers
  module DateHelper
    def select_timezone(options = {}, html_options = {})
      options[:timezone_type] ||= 'short'
      DateTimeSelector.new(Time.zone.now, options, html_options).select_timezone
    end
  end
end

module DateTimeSelectorExt
  def select_datetime
    if @options[:tag] && @options[:ignore_date]
      select_time
    elsif @options[:tag]
      order = date_order.dup
      order -= [:hour, :minute, :second]

      @options[:discard_year]   ||= true unless order.include?(:year)
      @options[:discard_month]  ||= true unless order.include?(:month)
      @options[:discard_day]    ||= true if @options[:discard_month] || !order.include?(:day)
      @options[:discard_minute] ||= true if @options[:discard_hour]
      @options[:discard_second] ||= true unless @options[:include_seconds] && ( !@options[:discard_minute] || @options[:include_timezone] )
      @options[:discard_timezone] ||= true unless @options[:include_timezone]
      @options[:timezone_type] ||= "short" unless @options[:timezone_type]

      if @datetime && @options[:discard_day] && !@options[:discard_month]
        @datetime = @datetime.change(:day => 1)
      end

      [:day, :month, :year].each { |o| order.unshift(o) unless order.include?(o) }
      order += [:hour, :minute, :second] unless @options[:discard_hour]
      order += [:timezone] if @options[:include_timezone]

      build_selects_from_types(order)
    else
      "#{select_date}#{@options[:datetime_separator]}#{select_time}"
    end
  end

  def select_time
    order = []

    @options[:timezone_type] ||= "short" unless @options[:timezone_type]
    # TODO: Remove tag conditional
    if @options[:tag]
      @options[:discard_month]    = true
      @options[:discard_year]     = true
      @options[:discard_day]      = true
      @options[:discard_second] ||= true unless @options[:include_seconds]

      order += [:year, :month, :day] unless @options[:ignore_date]
    end

    order += [:hour, :minute]
    order << :second if @options[:include_seconds]
    order << :timezone if @options[:include_timezone]

    build_selects_from_types(order)
  end

  def select_second
    if @options[:use_hidden] || @options[:discard_second]
      build_hidden(:second, sec) if @options[:include_seconds]
      build_hidden(:second, 0) if !@options[:include_seconds] && @options[:include_timezone]
    else
      build_options_and_select(:second, sec)
    end
  end

  def select_timezone
    if @options[:use_hidden] || @options[:discard_timezone]
      build_hidden(:timezone, timezone) if @options[:include_timezone]
    else
      build_timezone_select
    end
  end

  private
  def build_timezone_select
    build_select(:timezone, build_timezone_options(timezone_list, @options[:timezone] || timezone))
  end

  def build_timezone_options(list, selected)
    tz_options = ""
    list.each { |offset, name|
      options = { :value => offset }
      options[:selected] = "selected" if [ name, offset ].include?(selected)
      if @options[:timezone_type].downcase == 'offset'
        tz_options << content_tag(:option, "GMT #{offset}", options) + "\n"
      else
        tz_options << content_tag(:option, "(GMT#{offset}) #{name}", options) + "\n"
      end
    }
    tz_options
  end

  def timezone_list
    tzlist = []
    case @options[:timezone_type].downcase
    when 'long'
      tzlist = ::ActiveSupport::TimeZone.all.map { |e|
        [ e.formatted_offset(false), e.name ]
      }
    when 'offset'
      tzlist = ::ActiveSupport::TimeZone.all.map { |e| [ e.formatted_offset(false) ] }.uniq
    when 'short'
      tzlist = ::ActiveSupport::TimeZone.all.map { |e|
        # get shortname from dummy instance
        [ e.formatted_offset(false), ActiveSupport::TimeWithZone.new("2000-01-01 00:00", e).zone ]
      }.uniq
    end
    if @options[:timezone_sort_by_name] && @options[:timezone_type].downcase != 'offset'
      tzlist.sort { |a,b| a[1] <=> b[1] }
    else
      tzlist.sort { |a,b| a[0].to_i <=> b[0].to_i }
    end
  end

  def timezone
    case @datetime
    when String
      @datetime
    when Time
      case @options[:timezone_type]
      when 'short'
        @datetime.zone
      when 'long'
        @datetime.time_zone.name
      when 'offset'
        h,m = @datetime.utc_offset.divmod(3600)
        format "%+03d%02d", h, m
      end
    when DateTime
      case @options[:timezone_type]
      when 'short'
        # no way?
        Time.now.zone
      when 'long'
        # no way?
        Time.zone.name
      when 'offset'
        @datetime.zone.sub(/:/,'')
      end
    else
    end if @datetime
  rescue
    case @options[:timezone_type]
    when 'short'
      Time.now.zone
    when 'long'
      Time.zone.name
    when 'offset'
      h,m = Time.zone.utc_offset.divmod(3600)
      format "%+03d%02d", h, m
    end
  end
end
