module Al
  module Utils
    class FilterByDate
      def self.new(filter_field)
        Module.new do
          define_method(:of_day) { |datetime = Date.today| where(filter_field => datetime.beginning_of_day..datetime.end_of_day) }
          define_method(:of_week) { |datetime = Date.today| where(filter_field => datetime.beginning_of_week..datetime.end_of_week) }
          define_method(:of_month) { |datetime = Date.today| where(filter_field => datetime.beginning_of_month..datetime.end_of_month) }
          define_method(:of_last_days) { |datetime = Date.today, days = 7| where(filter_field => datetime(days.days).beginning_of_day..datetime.end_of_day) }
          define_method(:of_last_weeks) { |datetime = Date.today, weeks = 5| where(filter_field => datetime.ago(weeks.weeks).beginning_of_week..datetime.end_of_week) }
          define_method(:of_last_months) { |datetime = Date.today, months = 11| where(filter_field => datetime.ago(months.months).beginning_of_month..datetime.end_of_month) }
        end
      end
    end
  end
end