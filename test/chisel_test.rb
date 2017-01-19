require'./test/test_helper'
require'./lib/chisel'

class ParserTest < Minitest::Test
  def incoming_text
    '# My Life in Desserts

    ## Chapter 1: The Beginning

    "You just *have* to try the cheesecake," he said. "Ever since it appeared in
    **Food & Wine** this place has been packed every night."'
  end

  def setup
    @parse = Parser.new
  end

  def test_can_convert_to_array
    parsed = @parse.turn_into_array("hi\n\nthere")
    assert_equal ["hi", "there"], parsed
  end

  def test_can_convert_line_breaks
    parsed_1 = @parse.convert_line_breaks("# hi")
    parsed_2 = @parse.convert_line_breaks("## there")
    parsed_3 = @parse.convert_line_breaks("### the #1 person")
    parsed_4 = @parse.convert_line_breaks("#### the #1 person")
    parsed_5 = @parse.convert_line_breaks("##### the #1 person")
    parsed_6 = @parse.convert_line_breaks("###### the #1 person")
    parsed_7 = @parse.convert_line_breaks("the #1 person")

    assert_equal "<h1>hi</h1>", parsed_1
    assert_equal "<h2>there</h2>", parsed_2
    assert_equal "<h3>the #1 person</h3>", parsed_3
    assert_equal "<h4>the #1 person</h4>", parsed_4
    assert_equal "<h5>the #1 person</h5>", parsed_5
    assert_equal "<h6>the #1 person</h6>", parsed_6
    assert_equal "<p>\nthe #1 person\n</p>\n", parsed_7
  end

  def test_can_convert_emphasize_or_bold
    parsed_1 = @parse.convert_emphasize("*hello* Beth") #em
    parsed_2 = @parse.convert_emphasize("**hello** Ilana") #<strong>
    parsed_3 = @parse.convert_emphasize("Seth says **hello Mike**")
    parsed_4 = @parse.convert_emphasize("**Seth says *hello Mike* deep dish is delish** hi **hi**")
    parsed_5 = @parse.convert_emphasize("*Seth says **hello Mike** deep dish is delish*")

    assert_equal "<em>hello</em> Beth", parsed_1
    assert_equal "<strong>hello</strong> Ilana", parsed_2
    assert_equal "Seth says <strong>hello Mike</strong>", parsed_3
    assert_equal "<strong>Seth says <em>hello Mike</em> deep dish is delish</strong> hi <strong>hi</strong>", parsed_4
    assert_equal "<em>Seth says <strong>hello Mike</strong> deep dish is delish</em>", parsed_5
  end

  def test_can_make_parse_an_ordered_list
    skip
    parser_1 = @parse.convert_line_breaks("* Sushi")
    parser_2 = @parse.convert_line_breaks("* Pizza")
    assert_equal "<ul>\n<li>Sushi</li>\n</ul>", parser_1
    assert_equal "<ul>\n<li>Pizza</li>\n</ul>", parser_2
  end

  def test_can_replace_special_characters
    parser_1 = @parse.replace_special_characters("Me & my dog love cheese")
    parser_2 = @parse.replace_special_characters('No, he would never say "cheesecake sucks"')
    parser_3 = @parse.replace_special_characters('No, Chris & I would never say "cheesecake sucks"')

    assert_equal "Me &amp; my dog love cheese", parser_1
    assert_equal 'No, he would never say &quot;cheesecake sucks&quot;', parser_2
    assert_equal 'No, Chris &amp; I would never say &quot;cheesecake sucks&quot;', parser_3
  end

  def test_does_parse_correctly
    parsed = @parse.convert_to_html(incoming_text)
    assert_equal "<h1>My Life in Desserts</h1>\n\n<h2>Chapter 1: The Beginning</h2>\n\n<p> &quot;You just <em>have</em> to try the cheesecake,&quot; he said. &quot;Ever since it appeared in <strong>Food &amp; Wine</strong> this place has been packed every night.&quot; </p>", parsed
  end
end
