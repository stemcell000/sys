# config/initializers/ransack.rb
#
# Custom ransack predicate to simplify query for date range
#
# See lib/ransack.rb in ransack gem
# See wiki https://github.com/activerecord-hackery/ransack/wiki/Custom-Predicates
Ransack::Adapters::ActiveRecord::Base.class_eval('remove_method :search')

Ransack.configure do |config|
  config.add_predicate 'has_any_term',
  arel_predicate: 'matches_any',
  formatter: proc { |v| v.scan(/\"(.*?)\"|(\w+)/).flatten.compact.map{|t| "%#{t}%"} },
  validator: proc { |v| v.present? },
  type: :string
end

Ransack.configure do |config|
  config.add_predicate 'has_every_term',
  arel_predicate: 'matches_all',
  formatter: proc { |v| v.scan(/\"(.*?)\"|(\w+)/).flatten.compact.map{|t| "%#{t}%"} },
  validator: proc { |v| v.present? },
  type: :string
end
