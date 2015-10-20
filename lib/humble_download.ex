defmodule HumbleDownload do
  import File
  
  def main([input, base_path]) do
    File.read!(input)
    |> Poison.decode!
    |> Enum.each(fn
      (%{"machine_name" => machine_name, "downloads" => downloads} = map) ->
        Enum.flat_map(downloads, &(Map.get(&1, "download_struct")))
        |> Enum.each(fn
          %{"human_size" => size, "md5" => md5, "url" => %{"web" => link}} ->
            filename = Regex.run(~r/.*\/(.*)\?.*/, link) |> Enum.at(1)
            name = Map.get(map, "human_name", machine_name)
            
            dir = base_path <> "/" <> machine_name
            target = dir <> "/" <> filename
            tmp = base_path <> "/tmp"
            
            if File.exists?(tmp), do: File.rm!(tmp)
            
            if !File.exists?(target) do
              download_check(name, size, link, md5, tmp, target, dir)
            else 
              IO.puts "\nExisting file found: \"#{target}\""
              IO.write "Validating MD5 checksum... "
              
              if md5 != md5_file(target) do
                IO.puts "Failed! Removing and re-downloading."
                File.rm!(target)
                download_check(name, size, link, md5, tmp, target, dir)
              else
                IO.puts "OK! Skipping."
              end
            end
            
          invalid_struct -> 
            put_struct_error(invalid_struct)
        end)
    end)
  end
  
  defp md5_file(file) do
    File.stream!(file, [], 2048)
    |> Enum.reduce(:crypto.hash_init(:md5), &(:crypto.hash_update(&2, &1)))
    |> :crypto.hash_final
    |> Base.encode16(case: :lower)
  end
  
  defp download_check(name, size, link, md5, tmp, target, dir, attempt \\ 1) do
    max_retries = 3
    IO.puts "\nProcessing: \"#{name}\", approximate size: #{size}"
    mkdir_p!(dir)
    
    IO.write "Downloading... "
    %HTTPoison.AsyncResponse{id: id} = HTTPoison.get!(link, %{}, stream_to: self)
    process(id, tmp)
    
    IO.write "Validating MD5 checksum... "
    
    if (attempt > max_retries) do
      IO.puts "Skipped! (Too many failed attempts)"
      File.rename(tmp, target)
    else
      if (md5 == md5_file(tmp)) do
        IO.puts "OK!"
        File.rename(tmp, target)
        IO.puts "Saved to: #{target}"
      else
        IO.puts "Failed! Retrying... (attempt: #{attempt} / #{max_retries})"
        download_check(name, size, link, md5, tmp, target, dir, attempt + 1)
      end
    end
  end
  
  defp put_struct_error(invalid_struct) do
    IO.puts :stderr, "Unable to download an item, please report this if you believe that it should work (please include data below)."
    IO.puts :stderr, inspect(invalid_struct)
  end
  
  defp process(id, tmp) do
    receive do
      %HTTPoison.AsyncStatus{code: code, id: ^id} ->
        if code == 200 do
          download(id, tmp)
        else
          throw "Links are no longer valid or a network error occurred."
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
        IO.puts "Done!"
    end
  end
end
