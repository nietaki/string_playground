defmodule Mix.Tasks.Benchmark do
  alias StringPlayground.Utils

  @moduledoc "runs the string operations benchmark"
  @shortdoc "runs benchmarks"

  @formatters [{Benchee.Formatters.Console, extended_statistics: false, comparison: true}]
  @benchee_opts [formatters: @formatters, warmup: 1, time: 2, memory_time: 1]

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    # Mix.shell().info(Enum.join(args, ":"))
    run_all = args == []

    if run_all || "String.at" in args do
      run_string_at()
    end

    if run_all || "slicing" in args do
      IO.puts("")
      run_string_slice()
    end

    if run_all || "palindromes" in args do
      IO.puts("")
      run_palindrome()
    end
  end

  def string_inputs() do
    [10, 100, 1000, 10_000, 100_000, 1_000_000]
    |> Enum.map(fn i ->
      {inspect(i), {div(i * 3, 4), Utils.generate_string(:alphanumeric, i)}}
    end)
    |> Map.new()
  end

  def run_string_at() do
    benchmarks = %{
      "String.at/2" => fn {len, input} -> String.at(input, div(len * 3, 4)) end,
      "binary_part/3" => fn {len, input} -> binary_part(input, div(len * 3, 4), 1) end
    }

    Benchee.run(benchmarks, [inputs: string_inputs()] ++ @benchee_opts)
  end

  def run_string_slice() do
    benchmarks = %{
      "String.slice" => fn {len, input} -> String.slice(input, 0, div(len * 3, 4)) end,
      "binary_part" => fn {len, input} -> binary_part(input, 0, div(len * 3, 4)) end
    }

    Benchee.run(benchmarks, [inputs: string_inputs()] ++ @benchee_opts)
  end

  def palindrome_inputs() do
    [10, 100, 1000, 10_000, 50_000]
    |> Enum.map(fn i ->
      {inspect(i), Utils.generate_string(:alphanumeric, div(i, 2))}
    end)
    |> Enum.map(fn {k, s} -> {k, s <> String.reverse(s)} end)
    |> Map.new()
  end

  def run_palindrome() do
    benchmarks = %{
      "check_palindrome_with_string_at" => &Utils.check_palindrome_with_string_at/1,
      "check_palindrome_with_binary_part" => &Utils.check_palindrome_with_binary_part/1,
      "check_palindrome_with_graphemes" => &Utils.check_palindrome_with_graphemes/1,
      "check_palindrome_with_string_reverse" => &Utils.check_palindrome_with_string_reverse/1,
      "check_palindrome_charlist" => &Utils.check_palindrome_charlist/1,
      "check_palindrome_charlist_optimized" => &Utils.check_palindrome_charlist_optimized/1
    }

    Benchee.run(benchmarks, [inputs: palindrome_inputs()] ++ @benchee_opts)
  end
end
