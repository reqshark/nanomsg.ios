/*
    Copyright 2015 Bent Cardan

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
*/

#import "ViewController.h"

#include <stdio.h>
#include <string.h>

#include "nn.h"
#include "inproc.h"
#include "pipeline.h"
#include "sleep.h"

/* test a nanomsg pub/sub over TCP transport. */

#define SOCKET_ADDRESS "inproc://yo"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
