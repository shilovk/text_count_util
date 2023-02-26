defmodule TextCountUtil do
  @moduledoc """
  Documentation for `TextCountUtil`.
  """

  alias TextCountUtil.Counter

  @doc """
  Calculate words count of text

  ## Examples

      iex> TextCountUtil.words_count("./test/fixtures/example.txt")
      5

  """
  @spec words_count(String.t()) :: non_neg_integer()
  def words_count(filename) do
    File.stream!(filename)
    |> Stream.with_index(1)
    |> Stream.map(&(do_count(&1)))
    |> Stream.map(&(get_count(&1)))
    |> Enum.sum
  end

  defp do_count({line, idx}) do
    {:ok, pid} = Counter.start_link(idx)
    GenServer.cast(pid, {:do_count, line})
    pid
  end

  defp get_count(pid) do
    GenServer.call(pid, :get_count)
  end
end
