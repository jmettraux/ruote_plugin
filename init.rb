
require 'ruote_plugin'

#
# init ruote engine

h = {}

h[:engine_class] = OpenWFE::CachedFilePersistedEngine
#h[:engine_class] = OpenWFE::Extras::DbPersistedEngine
  # the type of engine to use

h[:logger] = Logger.new "log/openwferu_#{RAILS_ENV}.log", 10, 1024000
h[:logger].level = (RAILS_ENV == 'production') ? Logger::INFO : Logger::DEBUG

h[:work_directory] = "work_#{RAILS_ENV}"

h[:ruby_eval_allowed] = true
  # the 'reval' expression and the ${r:some_ruby_code} notation are allowed

h[:dynamic_eval_allowed] = true
  # the 'eval' expression is allowed

#h[:definition_in_launchitem_allowed] = true

RuotePlugin.engine_init(h) \
  unless $0.match(/script\/generate$/)
    # don't start engine while using the generator

