require_relative '../lib/checklist'

class TestingChecklist
  include Checklist

  attr_accessor :world, :only, :except

  def initialize
    @world = "World"
    @true = true
    @only = false
    @except = false
  end

  checklist do
    check "World should contains the world string", except: :except do
      world == "World"
    end
    check "the truth", only: :only do
      @true == true
    end
  end
end