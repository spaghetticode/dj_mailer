module WorldExtensions
  attr_accessor :result

  def context_module
    @context_module ||= Module.new
  end
end

World(WorldExtensions)
