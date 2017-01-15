class Parser
  attr_reader :handle

  def initialize
    @handle = File.open("./lib/my_input.md", 'r')

  end

  def incoming_text
    @handle.read
  end

  def convert_to_html(incoming_text)
    arr = turn_into_array(incoming_text)
    final_html = arr.map do |line|
      a = convert_line_breaks(line)
      b = convert_emphasize(a)
      replace_special_characters(b)
    end
    final_html.join("\n\n")
  end

  def turn_into_array(incoming_text)
    incoming_text.split("\n\n")
  end

  def convert_line_breaks(incoming_text)
    line_as_arr = incoming_text.split(" ")
    number = (1...100)
    case line_as_arr[0]
      when "#"
        convert_header(line_as_arr, "h1")
      when "##"
        convert_header(line_as_arr, "h2")
      when "###"
        convert_header(line_as_arr, "h3")
      when "####"
        convert_header(line_as_arr, "h4")
      when "#####"
        convert_header(line_as_arr, "h5")
      when "######"
        convert_header(line_as_arr, "h6")
      when "*"
        convert_ul(line_as_arr)
      when "#{number}."
        convert_ol(line_as_arr)
      else 
        convert_paragraph(line_as_arr)
    end
  end

  def convert_header(line, header)
    line.delete_at(0)
    "<#{header}>#{line.join(" ")}</#{header}>"
  end

  def convert_paragraph(line)
    "<p>\n#{line.join(" ")}\n</p>\n"
  end

  def convert_emphasize(line)
    arr = line.split(" ")
    arr.map do |word|
      if word.include?("**") || word.include?("*")
        word.gsub!(/[*]{2}/, "</strong>")
        word.gsub!(/<\/strong>\b/, "<strong>")
        word.gsub!(/[*]{1}/, "</em>")
        word.gsub!(/<\/em>\b/, "<em>")
      else
        word
      end
    end
    arr.join(" ")
  end

  def replace_special_characters(line)
    if line.include?("&") || line.include?("\"" || "\'")
    line.gsub!(/[&"']/, "&" => "&amp;", "\"" => "&quot;", "\'" => "&quot;")
    else
      line
    end
  end

  def convert_list(line)
    # line.slice!(0..1)
    # line.delete_at(0)
    "<li>#{line.join}</li>\n"
  end

  def convert_ol(line)
    # line = line.split(" ").delete_at(0)
    line.delete_at(0)    
    "<ol>\n#{convert_list(line)}</ol>\n"
  end

  def convert_ul(line)
    # line = line.slice!(0..1)
    line.delete_at(0)    
    "<ul>\n#{convert_list(line)}</ul>\n"
  end
end