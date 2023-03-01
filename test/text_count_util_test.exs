defmodule TextCountUtilTest do
  use ExUnit.Case
  doctest TextCountUtil

  test "words_count" do
    assert 10 = TextCountUtil.words_count("./test/fixtures/example.txt")
  end

  test "words_count_chunk" do
    assert 10 = TextCountUtil.words_count_chunk("./test/fixtures/example.txt")
  end

  test "words_count_async" do
    assert 10 = TextCountUtil.words_count_async("./test/fixtures/example.txt")
  end

  test "words_count_flow" do
    assert 10 = TextCountUtil.words_count_flow("./test/fixtures/example.txt")
  end
end
