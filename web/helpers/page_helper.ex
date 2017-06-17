defmodule Mutombofon.PageHelper do
  def file_recent?(x) do
    {:ok, times} = File.stat(x, time: :posix)

    :os.system_time(:seconds) - times.ctime < 600
  end  
end
