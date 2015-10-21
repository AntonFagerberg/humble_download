HumbleDownload
==============
HumbleDownload is used for downloading and making a complete back-up of your entire library from [Humble Bundle](http://humblebundle.com/). It will download everything: games, books, music etc and try to group them together in folders based on the names (which isn't perfect unfortunately).

## Build the project
First, [install Elixir](http://elixir-lang.org/install.html).

Execute the following from the project root:
```
mix deps.get
mix escript.build
```

This will create the executable file "humble_download" which can be run on any system which has the Erlang runtime installed.

To run it:
```
./humble_download <input file> <download folder> "<cookie string>"
```

Example:
```
./humble_download my-input-file my-output-folder "eyJ..j|1445...2|2...b211"
```

## Create the input file & cookie string
The input file should contain your game keys, one game key per line. To get your game keys, go to [HumbleBundle.com](https://www.humblebundle.com), sign in and go to your library. Once on the library page, open the developer console in your browser and paste the following code snippet: `gamekeys.forEach(function(key) { console.log(key); });`. This will print all game keys to the console. Save them to a file, one key per line.

The cookie string is a little bit trickier to get. You need to get the value of the cookie named `_simpleauth_sess`. It is marked as `isHttpOnly` which means that you can't access it with code like we did before. Sign in on [HumbleBundle.com](https://www.humblebundle.com) and open the developer tools in your browser, go to storage and locate the cookie there. Copy paste the value from `_simpleauth_sess`. Here's how you find it in [Firefox](https://developer.mozilla.org/en-US/docs/Tools/Storage_Inspector) and in [Chrome](https://developer.chrome.com/devtools/docs/resource-panel#cookies).

It is a little tricky to copy the actual value, in Firefox first click the row with `_simpleauth_sess`, then on `_simpleauth_sess` in the other menu far to the right under data, press `ctrl + c` or `cmd + c` to copy. You'll get a string with `_simpleauth_sess:"eyJfc...9"`, just remove the first `_simpleauth_sess:` part and keep the rest as the cookie string.).

It is a little bit easier in Chrome, simply tripple-click the appropriate cell in the table to mark it and use `ctrl + c` or `cmd + c` to copy. When pasting, be sure to surround the string in quotation marks ("") and remove trailing blank spaces.

Do not share your private data with anyone!

## Important!
The cookie string and the game keys are timed-based and they will expire after a while (a couple of days). When that happens, create another input file and cookie string as before and restart humble_download as you did before but with the new information. The previously downloaded files will not be downloaded again.

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
