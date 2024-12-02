defmodule FileReader do
  def process_file(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
    |> Enum.to_list()
  end

  defp parse_line(line) do
    line
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  def part1(reports) do
    reports
    |> Enum.filter(&check_safety(&1))
    |> Enum.count()
  end

  defp check_pair(x, y) do
    cond do
      y >= x + 1 and y <= x + 3 -> :ascending
      y <= x - 1 and y >= x - 3 -> :descending
      true -> :invalid
    end
  end

  defp find_invalid_index([a, b | rest], index \\ 1) do
    case check_pair(a, b) do
      :invalid -> index
      pattern -> check_sequence([b | rest], pattern, index + 1)
    end
  end

  defp check_sequence([_], _, _), do: nil

  defp check_sequence([a, b | rest], pattern, index) do
    case {pattern, check_pair(a, b)} do
      {p, p} -> check_sequence([b | rest], p, index + 1)
      _ -> index
    end
  end

  defp check_safety(report) do
    case find_invalid_index(report) do
      nil -> true
      _ -> false
    end
  end

  def part2(reports) do
    reports
    |> Enum.filter(&check_safety2(&1))
    |> Enum.count()
  end

  defp check_safety2(report) do
    case find_invalid_index(report) do
      nil ->
        true

      index ->
        # Find error index. Try to remove each of the 2 numbers before it.
        [0, -1, -2]
        |> Enum.map(fn offset -> remove_at_index(report, index + offset) end)
        |> Enum.any?(&check_safety/1)
    end
  end

  defp remove_at_index(list, index) when index >= 0 do
    for {x, i} <- Enum.with_index(list),
        i != index,
        do: x
  end

  defp remove_at_index(list, _), do: list
end

# Get filename from command line args and process it
[filename | _] = System.argv()

reports =
  FileReader.process_file(filename)

FileReader.part1(reports)
|> IO.inspect(label: "Part1: ")

FileReader.part2(reports)
|> IO.inspect(label: "Part2: ")
