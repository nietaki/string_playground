defmodule Mix.Tasks.Benchmark do
  alias StringPlayground.Utils

  @moduledoc "runs the string operations benchmark"
  @shortdoc "runs benchmarks"

  @formatters [{Benchee.Formatters.Console, extended_statistics: false, comparison: true}]
  @benchee_opts [formatters: @formatters, warmup: 1, time: 2]

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    # Mix.shell().info(Enum.join(args, " "))
    run_string_at()
    IO.puts "=============================================="
    run_string_at()
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
      "String.at" => fn {len, input} -> String.at(input, div(len * 3, 4)) end,
      "binary_part" => fn {len, input} -> binary_part(input, div(len * 3, 4), 1) end
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
end
