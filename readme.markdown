# iOS views

## [tcp_local_sub_obj.m](ViewController.m/tcp_local_sub_objc.m)
simplest recv socket without fd poll. may consume high device energy.

## [tcp_local_sub_objc_lowenergy.m](ViewController.m/tcp_local_sub_objc_lowenergy.m)
low energy version helps spare device battery.

![energyreport](http://cldup.com/GhJ9Ys75wQ-3000x3000.png)

Uses nanomsg fd poll composed into a utility function:
```c
int getevents (int s, int events, int timeout);
```

Combined with Apple's GCD global background queue. Priority is set to: `DISPATCH_QUEUE_PRIORITY_BACKGROUND`

### What the loop does in the background:
When nanomsg fd poll operation returns indicating that the socket is ready for
I/O, call nn_recv to perform I/O, storing the result in a buffer and copying it
into NSString.

Next, Apple's dispatch_async retrieves the main queue and potentially does some
UI update using the NSString created from the nanomsg buffer.

```objective-c
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
```

![procview](http://cldup.com/KpO85rO_vN-3000x3000.png)

## [ws_fancy.m](ViewController.m/ws_fancy.m)
using nanomsg posix threads example uses websocket transport for msg delivery
