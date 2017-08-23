module Blending
  extend ActiveSupport::Concern

  included do |object|
    after_save :make_juice if object.name == "Apple"
  end

  def make_juice
    puts "Calling make juice method"
  end
end