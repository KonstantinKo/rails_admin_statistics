require "rails_admin_statistics/engine"
#require 'pry'

module RailsAdminStatistics
  def self.per_cweek
    first_year = 2014 # config!
    first_cweek = 37 # config!
    this_year = Time.now.year
    this_cweek = Time.now.to_date.cweek

    (first_year..this_year).each do |year|
      start_cweek = (year == first_year ? first_cweek : 1)
      end_cweek = (year == this_year ? this_cweek : 52)
      (start_cweek..end_cweek).each do |cweek|
        yield cweek, year
      end
    end
  end

  # include => instance method / extend => class method
  def _stats
    [{
      name: 'General',
      weekly: _calculate_stats(true),
      cumulative: _calculate_stats(false)
    }]
  end
  alias :stats :_stats

  private

    def _calculate_stats use_start_time = true
      @_stats = {created: []}

      RailsAdminStatistics.per_cweek do |cweek, year|
        stat = _calculate_stat :created, use_start_time, cweek, year
        @_stats[:created] << stat
      end

      if self.attribute_method? :approved_at
        @_stats[:approved] = []

        RailsAdminStatistics.per_cweek do |cweek, year|
          stat = _calculate_stat :approved, use_start_time, cweek, year
          @_stats[:approved] << stat
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
      [start_time.to_i * 1000, count]
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
          proc do
            @stats = @abstract_model.model.stats

            render action: :statistics
          end
        end
      end
    end

    class Model
      register_instance_option :statistics do
      end
    end

    module Sections
      class Statistics < RailsAdmin::Config::Sections::Base
        register_instance_option :first_year do
          Time.now.year
        end
        register_instance_option :first_cweek do
          Time.now.strftime("%U").to_i
        end
      end
    end
  end
end
