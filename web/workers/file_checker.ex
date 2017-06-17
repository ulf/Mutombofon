defmodule Mutombofon.FileChecker do
  require Logger

  def check_for_files() do
    files = Path.wildcard("/home/ulf/Audio/*.mp3")
    |> Enum.filter(&Mutombofon.PageHelper.file_recent?/1)

    Logger.debug(files)

    Mutombofon.Endpoint.broadcast("room:lobby", "new:files", %{files: files})
  end
end
