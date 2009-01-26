#
#--
# Copyright (c) 2008-2009, John Mettraux, Tomaso Tosolini OpenWFE.org
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# . Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# . Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# . Neither the name of the "OpenWFE" nor the names of its contributors may be
#   used to endorse or promote products derived from this software without
#   specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#++
#

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

  h[:engine_class] ||= OpenWFE::CachedFilePersistedEngine
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
    require 'lib/ruote.rb'
    puts '.. found lib/ruote.rb'
  rescue LoadError
    puts '.. did not find any lib/ruote.rb, skipping'
  end

end

