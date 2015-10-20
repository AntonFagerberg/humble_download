HumbleDownload
==============
HumbleDownload is used for downloading / making a complete back-up of your library from [Humble Bundle](http://humblebundle.com/) to your computer. It will download everything: games, books, music etc and try to group them together in folders based on the names (which isn't perfect unfortunately).

## Build the project
First, [install Elixir](http://elixir-lang.org/install.html).

Execute the following from the project root:
```
mix deps.get
mix escript.build
```

This will create the executable file "humble_download" which can be run on any system which has the Erlang runtime installed.

```
./humble_download <input file> <download folder>
```

## Create the input file
Copy-paste the code from `humbledownload.js` in to the developer console in your browser when you're viewing your library on the Humble Bundle site. Copy-paste the result to a new text-file and use it as the input file as described above. If the copied data is very large, use an editor like Sublime Text to save it - or if you're on a Mac, you can use `pbpaste > some_file_name` in the terminal to create the file with the contents of the copied data.

## Important!
The links are timed-based and will expire. When that happens, create another input file as before and restart humble_download with the new input file. The previously downloaded files will not be downloaded again.

### License
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
