# termbox
Newlisp bindings for the termbox library https://github.com/nsf/termbox :
"Termbox is a library that provides minimalistic API which allows the programmer to write text-based user interfaces."

You should start termbox from the terminal: newlisp termbox. 
The newlisp API consists of a few functions see below , for full descriptions, parameters and return values see termbox.lsp.

To use this module you need the termbox dynamic library from https://github.com/nsf/termbox.
On a mac you can do brew install termbox, on my system it then is at:
 /usr/local/Cellar/termbox/1.1.2/lib/libtermbox.dylib.
On Linux use apt-get or other package manager. On Windows ..?
For linux the libtermbox.so file is searched for in /usr/lib/termbox/, /usr/local/lib/termbox/,
or /usr/pkg/lib/termbox/ , if not there change the directory in termbox.lsp.

Functions:
tb:init, tb:shutdown, tb:width, tb:height, tb:put-string, tb:box, tb:clear,  
tb:present, tb:set_cursor, tb:input-mode, tb:output-mode, tb:poll, tb:peek. 
