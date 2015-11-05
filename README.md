# nanomsg.ios
### ios/osx port of the [0.7 beta release](https://github.com/nanomsg/nanomsg/releases/tag/0.7-beta)

This directory contains all headers that interconnect various parts of
the system. The public API, the interface for protocols and transports etc.

# usage

in your xcode project root, run:
```bash
$ git clone https://github.com/reqshark/nanomsg.ios && rm nanomsg.ios/README.md
```

then go `add files to project`, selecting the entire `nanomsg.ios` directory,
and make sure to create groups (not folder references).

*note: in Xcode 7, click options (next to new folder) to choose 'Create groups'*

# example

```c
#include <stdio.h>
#include <string.h>

#include "nn.h"
#include "tcp.h"
#include "pipeline.h"
#include "sleep.h"

/* test a nanomsg pub/sub over TCP transport. */

#define SOCKET_ADDRESS "tcp://127.0.0.1:5555"

int main(int argc, const char * argv[]) {

  /* set up some pub sub sockets */
  int s1 = nn_socket (AF_SP, NN_PUB);
  int s2 = nn_socket (AF_SP, NN_SUB);

  /* subscriber needs to be switched on with a string filter, "" for all msgs */
  int r = nn_setsockopt (s2, NN_SUB, NN_SUB_SUBSCRIBE, "", 0);
  if(r > -1){
    printf ("subscriber socket set\n");
  } else {
    printf ("error setting subscription socket: %d\n", r);
    // return 1;
  }

  /* bind and connect sockets */
  nn_bind (s1, SOCKET_ADDRESS);
  nn_connect (s2, SOCKET_ADDRESS);
  nn_sleep (10);

  /* send a message */
  char *msg = "0123456789012345678901234567890123456789";
  nn_send (s1, msg, strlen(msg), 0);

  /* recv and allocate message to the address of a buffer */
  char *buf = NULL;
  int sz = nn_recv (s2, &buf, NN_MSG, 0);
  buf[sz] = '\0';

  printf("cool: %s\n",buf);

  /* free that allocation */
  nn_freemsg (buf);

  //return 0;

}
```

# note about xcode
I got this warning and others like it:

![](https://cldup.com/L7g6pTj1vK-3000x3000.png)

You can fix it at <em><strong>Apple LLVM 6.0 - Warnings - All Languages<strong/></em> section of build settings.

![](https://cldup.com/Z6cXgdHPSI-2000x2000.png)

Click where it says <strong>Uninitialized variables</strong> to switch it from <strong>Yes (Aggressive)</strong> to <strong>No</strong>

![](https://cldup.com/yFyhHrGDce-2000x2000.png)

please suggest/fork pull-request and submit issues. license is MIT.

License
-------
Copyright 2015 Bent Cardan, nanomsg [AUTHORS](https://raw.githubusercontent.com/nanomsg/nanomsg/master/AUTHORS)
et al.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
