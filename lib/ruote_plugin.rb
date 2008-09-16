
module RuotePlugin

  def self.engine_init (application_context)

    engine_class = application_context.delete(:engine_class)

    @engine = engine_class.new(application_context)
  end

  def self.ruote_engine

    @engine
  end
end

