defmodule TextCountUtilTest do
  use ExUnit.Case
  doctest TextCountUtil

  test "words_count" do
    assert 136 = TextCountUtil.words_count("./test/fixtures/text.txt")
  end
end
