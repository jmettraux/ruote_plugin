
require 'ruote_plugin'

#
# init ruote engine

Ruote::Plugin.engine_init(

  :engine_class => OpenWFE::Engine,

  :work_directory => "work_#{RAILS_ENV}",

  :ruby_eval_allowed => true,
    # the 'reval' expression and the ${r:some_ruby_code} notation are allowed

  :dynamic_eval_allowed => true,
    # the 'eval' expression is allowed
)

#
# shutdown routine

if Module.constants.include?('Mongrel') then
  #
  # graceful shutdown for Mongrel by Torsten Schoenebaum

  class Mongrel::HttpServer
    alias :old_graceful_shutdown :graceful_shutdown
    def graceful_shutdown
      Ruote::Plugin.ruote_engine.stop
      old_graceful_shutdown
    end
  end
else

  at_exit do
    #
    # make sure to stop the workflow engine when 'densha' terminates

    Ruote::Plugin.ruote_engine.stop
  end
end

