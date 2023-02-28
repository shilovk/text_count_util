defmodule TextCountUtilTest do
  use ExUnit.Case
  doctest TextCountUtil

  test "words_count" do
    assert 239465 = TextCountUtil.words_count("./test/fixtures/war_and_peace.txt")
  end

  test "words_count_chunk" do
    assert 239465 = TextCountUtil.words_count_chunk("./test/fixtures/war_and_peace.txt")
  end

  test "words_count_async" do
    assert 239465 = TextCountUtil.words_count_async("./test/fixtures/war_and_peace.txt")
  end

  #  test "words_count_flow" do
  #    assert 239465 = TextCountUtil.words_count_flow("./test/fixtures/war_and_peace.txt")
  #  end
end
