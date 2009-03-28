module ErrorsExtension
  
  def concat
    collect {|a, m| m }.join(", ")
  end
  
  def first_message
    return nil if empty?
    collect { |a, m| m }[0]
  end
  
end

ActiveRecord::Errors.send(:include, ErrorsExtension)