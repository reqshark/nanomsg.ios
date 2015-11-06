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

#include "nn.h"
#include "pubsub.h"
#include "tcp.h"

#include "int.h"
#include "err.h"
#include "attr.h"
#include "thread.h"
#include "sleep.h"

#include "ws.h"

int sub, pub, text, opt;
size_t sz;
static void test_send_impl (char *file, int line, int sock, char *data);
static void test_recv_impl (char *file, int line, int sock);
static void test_close_impl (char *file, int line, int sock);

#define test_send(s, d) test_send_impl (__FILE__, __LINE__, (s), (d))
#define test_recv(s) test_recv_impl (__FILE__, __LINE__, (s))
#define test_close(s) test_close_impl (__FILE__, __LINE__, (s))

#define NN_WS -4
#define NN_WS_MSG_TYPE 1

#define NN_WS_MSG_TYPE_TEXT 0x01
#define NN_WS_MSG_TYPE_BINARY 0x02

#define ADDR "ws://127.0.0.1:8090"

void worker (NN_UNUSED void *arg)  {
  /*  Wait 0.1 sec for the main thread to block. */
  nn_sleep (100);

  test_send (pub, "123412341234123412341234123412341234123");

  /*  Wait 0.1 sec for the main thread to process the previous message
   and block once again. */
  nn_sleep (100);

  test_send (pub, "123412341234123412341234123412341238888888888");
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  int sub, pub;

  // set up and bind a publisher
  pub = nn_socket(AF_SP, NN_PUB);
  int eid = nn_bind(pub, ADDR);
  nn_sleep(10);
  printf("pub socket connection id: %d\n", eid);

  // set up a subscriber socket
  sub = nn_socket(AF_SP, NN_SUB);

  sz = sizeof (opt);
  text = nn_setsockopt (sub, NN_WS, NN_WS_MSG_TYPE, &opt, sz);
  int r = nn_setsockopt (sub, NN_SUB, NN_SUB_SUBSCRIBE, "", 0);
  if(r > -1){
    printf ("subscriber socket set\n");
  } else {
    printf ("error setting subscription socket: %d\n", r);
  }

  // connect subscriber
  int eid2 = nn_connect (sub, ADDR);
  nn_sleep(20);
  printf("sub socket connection id: %d\n", eid2);

  struct nn_thread thread;

  nn_thread_init (&thread, worker, NULL);

  test_recv (sub);
  test_recv (sub);

  nn_thread_term (&thread);

  test_close(pub);
  test_close(sub);

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

static void NN_UNUSED test_send_impl (char *file, int line, int sock, char *data)
{
  size_t data_len;
  int rc;

  data_len = strlen (data);

  rc = nn_send (sock, data, data_len, 0);
  if (rc < 0) {
    fprintf (stderr, "Failed to send: %s [%d] (%s:%d)\n",
             nn_err_strerror (errno),
             (int) errno, file, line);
    nn_err_abort ();
  }
  if (rc != (int)data_len) {
    fprintf (stderr, "Data to send is truncated: %d != %d (%s:%d)\n",
             rc, (int) data_len,
             file, line);
    nn_err_abort ();
  }
}

static void NN_UNUSED test_recv_impl (char *file, int line, int sock)
{
  int sz;
  char *buf = NULL;

  // give incoming message a buffer address
  sz = nn_recv (sock, &buf, NN_MSG, 0);

  if (sz < 0) {
    fprintf (stderr, "Failed to recv: %s [%d] (%s:%d)\n",
             nn_err_strerror (errno),
             (int) errno, file, line);
    nn_err_abort ();
  }
  char ret[sz+1];
  memcpy(ret, buf, sz);
  printf("result: %s\n", buf);
  nn_freemsg(buf);

  ret[sz+1] = '\0';

  printf("result: %s\n", ret);

  return;
}

static void NN_UNUSED test_close_impl (char *file, int line, int sock)
{
  int rc;

  rc = nn_close (sock);
  if (rc != 0) {
    fprintf (stderr, "Failed to close socket: %s [%d] (%s:%d)\n",
             nn_err_strerror (errno),
             (int) errno, file, line);
    nn_err_abort ();
  }
}
