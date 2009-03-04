#--
# Copyright (c) 2008-2009, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.
#++


$: << File.dirname(__FILE__) + '/lib_ruote'
  # putting the engine in the load path anyway (migrations do need it)

#
# adding required gems to the Rails configuration

Rails.configuration.gem 'atom-tools', :lib => 'atom/tools'
Rails.configuration.gem 'rufus-dollar', :lib => 'rufus/dollar'
Rails.configuration.gem 'rufus-lru', :lib => 'rufus/lru'
Rails.configuration.gem 'rufus-mnemo', :lib => 'rufus/mnemo'
Rails.configuration.gem 'rufus-scheduler'
Rails.configuration.gem 'rufus-treechecker'
Rails.configuration.gem 'rufus-verbs', :lib => 'rufus/verbs'


#
# starting the ruote engine (if necessary)

unless caller.find { |l| l.match(/rake\.rb/) or l.match(/generate\.rb/) }
  #
  # makes sure the engine is not instantied in case of "rake db:migrate"
  # or 'script/generate'
  # lets the engine start for "rake test" anyway

  require 'ruote_plugin'


  #
  # init ruote engine

  h = defined?(RUOTE_ENV) ? RUOTE_ENV : {}

  h[:engine_class] ||= OpenWFE::FsPersistedEngine
  #h[:engine_class] = OpenWFE::Extras::DbPersistedEngine
    # the type of engine to use

  unless h[:logger]
    h[:logger] = Logger.new("log/ruote_#{RAILS_ENV}.log", 10, 1024000)
    #h[:logger].level = (RAILS_ENV == 'production') ? Logger::INFO : Logger::DEBUG
    h[:logger].level = Logger::INFO
  end

  h[:work_directory] ||= "work_#{RAILS_ENV}"

  h[:ruby_eval_allowed] ||= true
    # the 'reval' expression and the ${r:some_ruby_code} notation are allowed

  h[:dynamic_eval_allowed] ||= true
    # the 'eval' expression is allowed

  h[:definition_in_launchitem_allowed] ||= true
    # launchitems (process_items) may contain process definitions


  RuotePlugin.engine_init(h)

  begin
    require "#{RAILS_ROOT}/lib/ruote.rb"
    puts ".. found #{RAILS_ROOT}/lib/ruote.rb"
  rescue LoadError => le
    puts ".. couldn't load #{RAILS_ROOT}/lib/ruote.rb :\n#{le}"
  end

end

