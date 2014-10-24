require "rails_admin_statistics/engine"

module RailsAdminStatistics
  def self.per_cweek
    this_year = Time.now.year
    this_cweek = Time.now.to_date.cweek

    (1..this_cweek).each do |cweek|
      yield cweek, this_year
    end
  end

  # inlcude => instance method / extend => class method
  def stats
    {
      weekly: _calculate_stats(true),
      cumulative: _calculate_stats(false)
    }
  end

  private

    def _calculate_stats use_start_time = true
      @_stats = {created: []}

      RailsAdminStatistics.per_cweek do |cweek, year|
        _calculate_stat :created, use_start_time, cweek, year
      end

      if self.attribute_method? :approved_at
        @_stats[:approved] = []

        RailsAdminStatistics.per_cweek do |cweek, year|
          _calculate_stat :approved, use_start_time, cweek, year
        end
      end

      @_stats
    end

    def _calculate_stat field, use_start_time, cweek, year
      start_time = Date.commercial(year, cweek).to_datetime
      end_time = start_time.end_of_week

      count = self.select(:id).where("#{field}_at <= ?", end_time)
      count = count.where("#{field}_at >= ?", start_time) if use_start_time
      count = count.count
      @_stats[field] << [cweek, count]
    end
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class Statistics < Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection? do
          true
        end

        register_instance_option :link_icon do
          'fa fa-line-chart'
        end

        register_instance_option :controller do
          Proc.new do
            @stats = @abstract_model.model.stats

            render action: :statistics
          end
        end
      end
    end
  end
end

