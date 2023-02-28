defmodule TextCountUtil do
  @moduledoc """
  Documentation for `TextCountUtil`.
  """

  alias TextCountUtil.Counter

  @doc """
  Calculate text words count

  ## Examples

      iex> TextCountUtil.words_count("./test/fixtures/example.txt")
      5

  """
  @spec words_count(String.t()) :: non_neg_integer()
  def words_count(filename) do
    File.stream!(filename)
    |> Stream.map(&(do_count(&1)))
    |> Stream.map(&(get_count(&1)))
    |> Enum.sum
  end

  @doc """
  Calculate text words count by Stream.chunk_every and core numbers

  ## Examples

      iex> TextCountUtil.words_count_chunk("./test/fixtures/example.txt")
      5

  """
  @spec words_count_chunk(String.t()) :: non_neg_integer()
  def words_count_chunk(filename) do
    filename
    |> File.stream!()
    |> Stream.chunk_every(System.schedulers_online)
    |> Stream.map(fn cores_lines ->
      pids = Enum.map(cores_lines, &do_count/1) # the number of cores started
      results = Enum.map(pids, &get_count/1)    # collect results
      Enum.sum(results)
    end)
    |> Enum.sum()
  end

  @doc """
  Calculate text words count by Task.async_stream and core numbers

  ## Examples

      iex> TextCountUtil.words_count_async("./test/fixtures/example.txt")
      5

  """
  @spec words_count_async(String.t()) :: non_neg_integer()
  def words_count_async(filename) do
    filename
    |> File.stream!()
    |> Stream.chunk_every(System.schedulers_online)
    |> Stream.map(fn cores_lines ->
      cores_lines
      |> Task.async_stream(& &1 |> do_count() |> get_count())
      |> Enum.reduce(0, fn {:ok, num}, acc -> num + acc end)
    end)
    |> Enum.sum()
  end

  #  @doc """
  #  Calculate text words count by Flow and core numbers
  #
  #  ## Examples
  #
  #      iex> TextCountUtil.words_count_flow("./test/fixtures/example.txt")
  #      5
  #
  #  """
  #  @spec words_count_flow(String.t()) :: non_neg_integer()
  #  def words_count_flow(filename) do
  #    filename
  #    |> File.stream!()
  #    |> Flow.from_enumerable()
  #    |> Flow.map(& &1 |> do_count() |> get_count())
  #    |> Flow.partition()
  #    |> Flow.reduce(fn -> 0 end, fn num, acc -> num + acc end)
  #    |> Enum.sum()
  #  end

  defp do_count(line) do
    {:ok, pid} = Counter.start_link(line)
    # GenServer.cast(pid, {:do_count, line})
    pid
  end

  defp get_count(pid) do
    GenServer.call(pid, :get_count)
  end
end
