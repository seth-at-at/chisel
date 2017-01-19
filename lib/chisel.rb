class Parser
  attr_reader :handle, :incoming_text

  def initialize
    @handle = File.open(ARGV[0], 'r')
    @incoming_text = @handle.read
    @handle.close
  end

  def convert_to_html(incoming_text)
    arr = turn_into_array(incoming_text)
    final_html = arr.map do |line|
      line = convert_line_breaks(line)
      line = convert_emphasize(line)
      replace_special_characters(line)
    end
   final = final_html.join("\n")
   final
  end

  def turn_into_array(incoming_text)
    incoming_text.split("\n")
  end

  def convert_line_breaks(incoming_text)
    line_as_arr = incoming_text.split(" ")
    case line_as_arr[0]
      when nil
        ""
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
        ul_arr = []
        ul_arr << convert_list(line_as_arr)
        "<ul>\n\n" + ul_arr.join.delete("\"").delete("\[").delete("\]") + "\n\n</ul>\n\n"
      when "1.", "2.", "3.", "4.", "5.", "6.", "7.", "8.", "9.", "10."
        ul_arr = []
        ul_arr << convert_list(line_as_arr)
        "<ol>\n\n" + ul_arr.join.to_s.delete("\"").delete("\[").delete("\]") + "\n\n</ol>\n\n"
      else 
        convert_paragraph(line_as_arr)
    end
  end

  def convert_header(line, header)
    line.delete_at(0)
    "<#{header}>#{line.join(" ")}</#{header}>"
  end

  def convert_paragraph(line)
    line.delete_at(0)
    "<p>\n#{line.join(" ")}\n</p>\n"
  end

  def convert_emphasize(line)
    arr = line.split(" ")
    arr.map do |word|
      if word.include?("**") || word.include?("*")
        word.gsub!(/[*]{2}\b/, "<strong>")
        word.gsub!(/[*]{2}/, "</strong>")
        word.gsub!(/[*]{1}\b/, "<em>")
        word.gsub!(/[*]{1}/, "</em>")
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
    line.delete_at(0)
    "<li>#{line}</li>\n"
  end
 
  parse = Parser.new
  parse.incoming_text
  parse.convert_to_html(parse.incoming_text)
  File.open(ARGV[1], 'w') { |f| f.puts parse.convert_to_html(parse.incoming_text)}
end