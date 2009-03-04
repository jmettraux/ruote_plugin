#--
# Copyright (c) 2008-2009, John Mettraux, Tomaso Tosolini OpenWFE.org
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
# Made in Japan and Italy.
#++


require 'openwfe/representations'
require 'openwfe/engine/fs_engine'
require 'openwfe/extras/engine/db_persisted_engine'
require 'openwfe/extras/expool/db_errorjournal'
require 'openwfe/extras/expool/db_history'


module RuotePlugin

  #
  # Inits the workflow engine with the given hash of options
  #
  def self.engine_init (application_context)

    #
    # start engine

    engine_class = application_context.delete(:engine_class)

    @engine = engine_class.new(application_context)

    #
    # init history

    @engine.init_service(:s_history, OpenWFE::Extras::QueuedDbHistory)

    #
    # override error_journal with the db flavour

    @engine.init_service(:s_error_journal, OpenWFE::Extras::DbErrorJournal)

    #
    # let engine reload expressions from its expool
    # (let sleep and cron expressions, timeouts and the like get rescheduled)
    #
    # (this should normally be done by the app itself, once all the participants
    # have been registered)

    @engine.reload

    puts '.. Ruote workflow/BPM engine started (ruote_plugin)'
  end

  #
  # Stops the workflow engine (if one was started)
  #
  def self.engine_stop

    @engine && @engine.stop
  end

  #
  # Returns the workflow engine
  #
  def self.ruote_engine

    @engine
  end
end


#
# opening the ActionController base to provide a handy 'ruote_engine' method.

class ActionController::Base

  def self.ruote_engine
    RuotePlugin.ruote_engine
  end

  def ruote_engine
    RuotePlugin.ruote_engine
  end
end

#
# A Rails specialization of the representations.rb PlainLinkGenerator,
# generates absolute links.
#
class LinkGenerator < OpenWFE::PlainLinkGenerator

  def initialize (request=nil)
    @request = request
  end

  protected

    def link (rel, res, id=nil)

      href, rel = super

      if @request
        [ "#{@request.protocol}#{@request.host}:#{@request.port}#{href}", rel ]
      else
        [ href, rel ]
      end
    end
end


#
# shutdown routine, making sure the workflow engine is properly stopped
# when the application exits.

if Module.constants.include?('Mongrel') then
  #
  # graceful shutdown for Mongrel by Torsten Schoenebaum

  class Mongrel::HttpServer
    alias :old_graceful_shutdown :graceful_shutdown
    def graceful_shutdown
      RuotePlugin.engine_stop if RuotePlugin.ruote_engine
      old_graceful_shutdown
    end
  end
else

  at_exit do
    #
    # make sure to stop the workflow engine when 'densha' terminates

    RuotePlugin.engine_stop if RuotePlugin.ruote_engine
  end
end

