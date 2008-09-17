
require 'ruote_plugin'

#
# init ruote engine

RuotePlugin.engine_init(

  :engine_class => OpenWFE::Engine,

  :work_directory => "work_#{RAILS_ENV}",

  :ruby_eval_allowed => true,
    # the 'reval' expression and the ${r:some_ruby_code} notation are allowed

  :dynamic_eval_allowed => true
    # the 'eval' expression is allowed
)

