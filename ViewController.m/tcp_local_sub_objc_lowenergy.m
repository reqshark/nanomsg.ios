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
#include "fdpoll.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  int s = nn_socket (AF_SP, NN_SUB);

  /* subscriber needs to be switched on with a string filter, "" for all msgs */
  int r = nn_setsockopt (s, NN_SUB, NN_SUB_SUBSCRIBE, "", 0);
  if(r > -1){
    printf ("subscriber socket set\n");
  } else {
    printf ("error setting subscription socket: %d\n", r);
    // return 1;
  }

  /* connect socket */
  nn_connect (s, ADDR);
  nn_sleep (10);

  /* using a global background queue */
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    while(1) {
      if(getevents(s, NN_IN, 10) == 1) {

        char *buf = msgGet(s);
        NSString *msg = @(strcat(buf,"\n"));
        nn_freemsg (buf);

        dispatch_async(dispatch_get_main_queue(), ^{
          printf("dispatch async fired\n");
          NSLog(@"%@", msg);
        });
      }
    }
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
