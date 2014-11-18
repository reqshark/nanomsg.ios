# nanomsg.ios
### an uncompiled ios/osx port of the [0.5 beta release](https://github.com/nanomsg/nanomsg/releases/tag/0.5-beta)

This directory contains all headers that interconnect various parts of
the system. The public API, the interface for protocols and transports etc.

# usage

in your xcode project, run:
```bash
$ git clone https://github.com/reqshark/nanomsg.ios.git
```

then go `add files to project`, selecting the entire `nanomsg.ios` directory.

# example

```c
#include <stdio.h>
#include <string.h>

#include "nn.h"
#include "tcp.h"
#include "pipeline.h"
#include "sleep.h"

/*  Tests a nanomsg pipe over TCP transport. */

#define SOCKET_ADDRESS "tcp://127.0.0.1:5555"

int main(int argc, const char * argv[]) {

  //set up some sockets
  int s1 = nn_socket (AF_SP, NN_PUSH);
  int s2 = nn_socket (AF_SP, NN_PULL);

  //bind and connect sockets
  nn_bind (s1, SOCKET_ADDRESS);
  nn_connect (s2, SOCKET_ADDRESS);
  nn_sleep (10);

  //send a message
  char *msg = "0123456789012345678901234567890123456789";
  nn_send (s1, msg, strlen(msg), 0);

  //recv a message
  //allocate incoming message to the address of a buffer
  char *buf = NULL;
  nn_recv (s2, &buf, NN_MSG, 0);
  printf("cool: %s\n",buf);

  //free that allocation
  nn_freemsg (buf);
  //return 0;

}
```

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