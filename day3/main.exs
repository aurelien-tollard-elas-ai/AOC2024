defmodule FileReader do
  def process_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        all_patterns = ~r/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/

        Regex.scan(all_patterns, content, capture: :all)
        |> Enum.map(fn match ->
          case match do
            ["don't()"] ->
              {-1, -1}

            ["do()"] ->
              {0, 0}

            _ ->
              [num1, num2] = [Enum.at(match, 1), Enum.at(match, 2)]
              {String.to_integer(num1), String.to_integer(num2)}
          end
        end)

      {:error, reason} ->
        {:error, "Failed to read file: #{reason}"}
    end
  end

  def part1(ops) do
    ops
    |> Enum.filter(fn
      {num1, num2} when num1 == -1 -> false
      _ -> true
    end)
    |> Enum.reduce(0, fn {num1, num2}, acc ->
      acc + num1 * num2
    end)
  end

  def part2(ops) do
    ops
    |> Enum.filter(fn
      {num1} when num1 == 1 or num1 == 0 -> false
      _ -> true
    end)
    |> Enum.reduce({0, false}, fn {num1, num2}, {acc, skip} ->
      cond do
        num1 == 0 -> {acc, false}
        skip -> {acc, true}
        num1 == -1 -> {acc, true}
        true -> {acc + num1 * num2, false}
      end
    end)
    |> elem(0)
  end
end

# Get filename from command line args and process it
[filename | _] = System.argv()

ops =
  FileReader.process_file(filename)
  |> IO.inspect(label: "Operations: ")

FileReader.part1(ops)
|> IO.inspect(label: "Part1: ")

FileReader.part2(ops)
|> IO.inspect(label: "Part2: ")
