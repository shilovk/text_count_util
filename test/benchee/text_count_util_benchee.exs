# mix run test/benchee/text_count_util_benchee.exs

filename = "test/fixtures/war_and_peace.txt"

Benchee.run(
  %{
    "words_count" => fn -> TextCountUtil.words_count(filename) end,
    "words_count_chunk" => fn -> TextCountUtil.words_count_chunk(filename) end,
    "words_count_async" => fn -> TextCountUtil.words_count_async(filename) end
  },
  time: 10,
  memory_time: 2,
  warmup: 3,
  formatters: [
    {Benchee.Formatters.HTML, file: "test/benchee/output/results.html", auto_open: false},
    Benchee.Formatters.Console
  ]
)
