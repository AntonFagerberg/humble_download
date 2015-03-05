defmodule HumbleDownload do
  import File
  
  def main([input, base_path]) do
    File.read!(input)
    |> String.split("\n")
    |> Enum.chunk(3)
    |> Enum.each(fn([name, filename, url]) ->
      dir = base_path <> "/" <> name
      target = dir <> "/" <> filename
      tmp = base_path <> "/tmp"
      
      if (File.exists?(tmp)), do: File.rm!(tmp)
      
      if (!File.exists?(target)) do
        IO.write("Downloading: #{filename}")
        mkdir_p!(dir)
        %HTTPoison.AsyncResponse{id: id} = HTTPoison.get!(url, %{}, stream_to: self)
        process(id, tmp)
        File.cp!(tmp, target)
        File.rm!(tmp)
      else
        IO.puts("Skipping: #{filename}")
      end
    end)
  end
  
  defp process(id, tmp) do
    receive do
      %HTTPoison.AsyncStatus{code: code, id: ^id} ->
        if (code == 200) do
          download(id, tmp)
        else
          throw("Links are no longer valid...")
        end
    end
  end
  
  defp download(id, tmp) do
    receive do
      %HTTPoison.AsyncHeaders{headers: _headers, id: ^id} ->
        download(id, tmp)
      
      %HTTPoison.AsyncChunk{chunk: chunk, id: ^id} ->
        File.write(tmp, chunk, [:append])
        download(id, tmp)
      
      %HTTPoison.AsyncEnd{id: ^id} ->
        IO.puts(" [done]")
    end
  end
end
