defmodule FileReader do
  def process_file(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def part1(lines) do
    h =
      lines
      |> find_h()
      |> Enum.count()

    v =
      lines
      |> find_v()
      |> Enum.count()

    d =
      lines
      |> find_d()
      |> Enum.count()

    h + v + d
  end

  defp find_h(lines) do
    xmas_horizontal = ~r/(?=XMAS)/
    samx_horizontal = ~r/(?=SAMX)/

    lines
    |> Enum.join(".")
    |> then(fn string ->
      Regex.scan(xmas_horizontal, string) ++ Regex.scan(samx_horizontal, string)
    end)
  end

  defp find_v(lines) do
    line_width = lines |> List.first() |> String.length()

    xmas_vertical = ~r/(?=X#{".{#{line_width}}"}M#{".{#{line_width}}"}A#{".{#{line_width}}"}S)/
    samx_vertical = ~r/(?=S#{".{#{line_width}}"}A#{".{#{line_width}}"}M#{".{#{line_width}}"}X)/

    lines
    |> Enum.join("/")
    |> then(fn string ->
      Regex.scan(xmas_vertical, string) ++ Regex.scan(samx_vertical, string)
    end)
  end

  defp find_d(lines) do
    line_width = lines |> List.first() |> String.length()

    d1 = ~r/(?=X#{".{#{line_width - 1}}"}M#{".{#{line_width - 1}}"}A#{".{#{line_width - 1}}"}S)/
    d2 = ~r/(?=X#{".{#{line_width + 1}}"}M#{".{#{line_width + 1}}"}A#{".{#{line_width + 1}}"}S)/
    d3 = ~r/(?=S#{".{#{line_width - 1}}"}A#{".{#{line_width - 1}}"}M#{".{#{line_width - 1}}"}X)/
    d4 = ~r/(?=S#{".{#{line_width + 1}}"}A#{".{#{line_width + 1}}"}M#{".{#{line_width + 1}}"}X)/

    lines
    |> Enum.join("/")
    |> then(fn string ->
      Regex.scan(d1, string) ++
        Regex.scan(d2, string) ++ Regex.scan(d3, string) ++ Regex.scan(d4, string)
    end)
  end

  def part2(ops) do
    x =
      ops
      |> find_x()
      |> Enum.count()
      |> IO.inspect(label: "X: ")

    x
  end

  defp find_x(lines) do
    line_width = lines |> List.first() |> String.length()

    x1 = ~r/(?=M.M#{".{#{line_width - 1}}"}A#{".{#{line_width - 1}}"}S.S)/
    x2 = ~r/(?=M.S#{".{#{line_width - 1}}"}A#{".{#{line_width - 1}}"}M.S)/
    x3 = ~r/(?=S.M#{".{#{line_width - 1}}"}A#{".{#{line_width - 1}}"}S.M)/
    x4 = ~r/(?=S.S#{".{#{line_width - 1}}"}A#{".{#{line_width - 1}}"}M.M)/

    lines
    |> Enum.join("/")
    |> then(fn string ->
      Regex.scan(x1, string) ++
        Regex.scan(x2, string) ++ Regex.scan(x3, string) ++ Regex.scan(x4, string)
    end)
  end
end

# Get filename from command line args and process it
[filename | _] = System.argv()

lines =
  FileReader.process_file(filename)
  |> IO.inspect(label: "Input: ")

FileReader.part1(lines)
|> IO.inspect(label: "Part1: ")

FileReader.part2(lines)
|> IO.inspect(label: "Part2: ")
