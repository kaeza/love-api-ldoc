
# love-api-ldoc

This is a (not so) simple script to generate [LDoc][LDoc]-based documentation
from the [API tables][love-api] provided by the [LÖVE][love2d] community.

## License

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>

## Requirements

* [Lua][Lua] 5.1, 5.2, 5.3, or [LuaJIT][LuaJIT]
  (tested under Lua 5.1 and LuaJIT 2.0.4).
* [`love-api`][love-api]: The API tables (provided as Git submodule).
* [LDoc][LDoc]: To process the output of this script.

## Running

Install the required software, change directory to the root of this repo,
then run `./main.lua` (or `lua main.lua`). You should get a `tmp` directory
holding the temporary `*.ldoc` files, and a `doc` directory holding the
output HTML.

[Lua]: http://lua.org
[LuaJIT]: http://luajit.org
[LDoc]: https://github.com/stevedonovan/LDoc
[love2d]: http://love2d.org
[love-api]: https://github.com/love2d-community/love-api
