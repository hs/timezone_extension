require 'timezone_extension'
ActiveRecord::Base.send(:remove_method, :instantiate_time_object)
ActiveRecord::Base.send(:include, TimezoneConverter)
ActionView::Helpers::DateTimeSelector::POSITION = {
    :year => 1, :month => 2, :day => 3, :hour => 4, :minute => 5, :second => 6, :timezone => 7
}.freeze
ActionView::Helpers::DateTimeSelector.send(:remove_method, :select_second)
ActionView::Helpers::DateTimeSelector.send(:remove_method, :select_datetime)
ActionView::Helpers::DateTimeSelector.send(:remove_method, :select_time)
ActionView::Helpers::DateTimeSelector.send(:include, DateTimeSelectorExt)
ActionController::Base.send(:include,MultiparameterGetter)
