module Remora
module UI
class TextBox < Label
  attr_accessor :multiline, :handler, :label, :mask
  
  def initialize *args
    @label = ''
    @text = 'Input box'
    super
  end
  
  def redraw
    super
    
    case @alignment
      when :center
        text.center width
      when :right
        text.rjust width
      else
        @display.place y1, x1 + text.size, "\e[s" if @display.active_control == self
    end
    @display.cursor = true if @display.active_control == self
    #print "\e[s" # save
  end
  
  def on_submit &blck
    @handler = blck
  end
  
  def value= val
    @text = val
  end
  def value
    @text
  end
  
  def text
    return @text if @label.empty?
    "#{@label}: #{@mask ? (@mask * @text.size) : @text}"
  end
  
  def handle_char char
    if char == "\n" && !@multiline
      @handler.call @text if @handler
      @text = ''
    elsif char == "\177"
      @text.slice! -1
    else
      @text += char
    end
    redraw
  end
end
end
end
