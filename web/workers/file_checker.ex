defmodule Mutombofon.FileChecker do
  require Logger

  def run() do
    n = 10
    for i <- 1..n do
      check_for_files()
      :timer.sleep( round((60 / (n+1)) * 1000))
      i
    end
  end

  def check_for_files() do
    files = Path.wildcard("/home/ulf/Audio/*.wav")
    |> Enum.filter(&Mutombofon.PageHelper.file_recent?/1)

    #Logger.debug("files: ", files)

    if length(files) > 0 do
      Logger.debug("Sending: #{files}")
      file = List.last(files) |> String.replace("/home/ulf", "")
      Mutombofon.Endpoint.broadcast("room:lobby", "new:files", %{file: file, level: 1, duration: 12})
      # Mutombofon.Endpoint.broadcast "room:lobby", "new:files", %{file: "/Audio/2017-06-19-194219.mp3", level: 1}
    end
  end
end
