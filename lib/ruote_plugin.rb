#
#--
# Copyright (c) 2008, John Mettraux, Tomaso Tosolini OpenWFE.org
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

require 'openwfe/engine/file_persisted_engine'
require 'openwfe/extras/engine/db_persisted_engine'
require 'openwfe/extras/expool/dbhistory'

require 'misc'


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

    @engine.init_service('history', OpenWFE::Extras::DbHistory)

    #
    # let engine reload expressions from its expool
    # (let sleep and cron expressions, timeouts and the like get rescheduled)

    @engine.reload
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

    RuotePlugin.engine_stop
  end
end

