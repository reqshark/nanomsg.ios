# nanomsg.ios
### this is an unncompiled, dirty but working ios/osx port of the [0.5 beta release](https://github.com/nanomsg/nanomsg/releases/tag/0.5-beta)

This directory contains all headers that interconnect various parts of
the system. The public API, the interface for protocols and transports etc.

# usage

in your xcode project, run:
```bash
$ git clone https://github.com/reqshark/nanomsg.ios.git
```

then go `add files to project`, selecting the entire `nanomsg.ios` directory.

I will port the nanomsg test suite for osx/ios soon.

Also instead of just adding the header files plus their internal components directly, the future plan here is to script that into a download for versioned snapshots of the nanomsg library. This future script would ideally place such header files and their internal components based on the version of the network library that works for you.

please suggest/fork pull-request and submit issues.

license inspired by MIT:

License
-------

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

For more information, please refer to <http://www.wtfpl.net/>