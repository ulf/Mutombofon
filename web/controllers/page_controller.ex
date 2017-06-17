defmodule Mutombofon.PageController do
  use Mutombofon.Web, :controller
  import Mutombofon.PageHelper

  def index(conn, _params) do
    render conn, "index.html"
  end

  def list(conn, _params) do
    files = Path.wildcard("/home/ulf/Audio/*.mp3")
    |> Enum.filter(&Mutombofon.PageHelper.file_recent?/1)

    render conn, "list.html", files: files
  end

end
