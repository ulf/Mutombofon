defmodule Mutombofon.PageController do
  use Mutombofon.Web, :controller
  import Mutombofon.PageHelper

  def index(conn, _params) do
    render conn, "index.html"
  end

  def play(conn, params) do
    if params["file"] do
      prefix = Application.app_dir(:mutombofon, "")
      [base, build] = String.split(prefix, "_")
      {:ok, file} = File.open "/tmp/play", [:write]
      IO.write(file, "#{base}priv/static/uploads/#{params["file"]}")
    end
    redirect conn, to: "/list"
  end

  def list(conn, _params) do
    files = Path.wildcard("/home/ulf/Audio/*.mp3")
    |> Enum.filter(&Mutombofon.PageHelper.file_recent?/1)

    uploads = Path.wildcard("priv/static/uploads/*.mp3")
    |> Enum.map(fn x -> String.replace(x, "priv/static/uploads/", "") end)

    render conn, "list.html", files: files, uploads: uploads
  end

  def upload(conn, _params) do
    files = Path.wildcard("priv/static/uploads/*.mp3")
    |> Enum.map(fn x -> String.replace(x, "priv/static/uploads/", "") end)
    render conn, "upload.html", files: files
  end

  def fileupload(conn, params) do
    if upload = params["file"] do
      File.cp(upload.path, "priv/static/uploads/#{upload.filename}")
    end

    redirect conn, to: "/upload"
  end
end
