# lib/core_extensions/string.rb
class String
  def numeric?
    Float(self) != nil rescue false
  end
end