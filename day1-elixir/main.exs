defmodule FileReader do
  def process_file(filename) do
    {list1, list2} =
      File.stream!(filename)
      # Remove trailing whitespace from each line
      |> Stream.map(&String.trim/1)
      # Process each line
      |> Stream.map(&parse_line/1)
      |> Enum.to_list()
      |> Enum.unzip()

    {Enum.sort(list1), Enum.sort(list2)}
  end

  defp parse_line(line) do
    line
    |> String.split("   ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1(list1, list2) do
    process_distance(list1, list2)
  end

  defp process_distance(list1, list2) do
    # Calculate distance between two points
    Enum.zip(list1, list2)
    |> Enum.map(fn {x, y} -> abs(x - y) end)
    |> Enum.sum()
  end

  def part2(list1, list2) do
    list2_counts = Enum.frequencies(list2)

    list1
    |> Enum.map(fn x -> Map.get(list2_counts, x, 0) * x end)
    |> Enum.sum()
  end
end

# Get filename from command line args and process it
[filename | _] = System.argv()
{list1, list2} = FileReader.process_file(filename)

FileReader.part1(list1, list2)
|> IO.inspect(label: "Part1: ")

FileReader.part2(list1, list2)
|> IO.inspect(label: "Part2: ")
