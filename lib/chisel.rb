class Parser
  attr_reader :handle
  def initialize
    # @handle = File.open(ARGV[0], "r")
    @handle = File.open("./lib/my_input.markdown", "r")
    # @handle_v2 = File.open("./lib/my_output.html", "w")

  end

  def incoming_text
    @handle.read
  end

  def convert_to_html(incoming_text)
    arr = turn_into_array(incoming_text)
    final_html = arr.map do |line|
      convert_line_breaks(line)
      convert_emphasize(line)
      replace_special_characters(line)
    end
    final_html.join("\n\n")
  end

  def turn_into_array(incoming_text)
    incoming_text.split("\n\n")
  end

  def convert_line_breaks(incoming_text)
    line_as_arr = incoming_text.split(" ")
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
      else 
        convert_paragraph(line_as_arr)
    end
  end

  def convert_header(line, header)
    line.delete_at(0)
    "<#{header}>#{line.join(" ")}</#{header}>"
  end

  def convert_paragraph(line)
    "<p>\n\n#{line.join(" ")}\n\n</p>\n\n"
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
    line.gsub!(/[&"]/, "&" => "&amp;", "\"" => "&quot;")
  end
end