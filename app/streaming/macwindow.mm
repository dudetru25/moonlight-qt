#include "macwindow.h"

#include "SDL_syswm.h"
#include "SDL_video.h"

#import <Cocoa/Cocoa.h>
#import <dispatch/dispatch.h>

namespace MacWindow {
  void configureAppStreamWindow(SDL_Window *window) {
    if (!window) {
      return;
    }

    SDL_SysWMinfo info;
    SDL_VERSION(&info.version);
    if (!SDL_GetWindowWMInfo(window, &info)) {
      return;
    }

    NSWindow *ns_window = info.info.cocoa.window;
    if (!ns_window) {
      return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
      NSWindowStyleMask style = [ns_window styleMask];
      style |= NSWindowStyleMaskTitled;
      style |= NSWindowStyleMaskResizable;
      style &= ~NSWindowStyleMaskClosable;
      style &= ~NSWindowStyleMaskMiniaturizable;
      style &= ~NSWindowStyleMaskFullScreen;
      style &= ~NSWindowStyleMaskFullSizeContentView;

      [ns_window setStyleMask:style];
      [ns_window setTitleVisibility:NSWindowTitleHidden];
      [ns_window setTitlebarAppearsTransparent:NO];
      [ns_window setShowsResizeIndicator:NO];
      [ns_window setCollectionBehavior:([ns_window collectionBehavior] &
                                        ~(NSWindowCollectionBehaviorFullScreenPrimary |
                                          NSWindowCollectionBehaviorFullScreenAuxiliary))];
      [ns_window setMovable:YES];
      [ns_window setMovableByWindowBackground:NO];

      NSButton *close_button = [ns_window standardWindowButton:NSWindowCloseButton];
      NSButton *miniaturize_button = [ns_window standardWindowButton:NSWindowMiniaturizeButton];
      NSButton *zoom_button = [ns_window standardWindowButton:NSWindowZoomButton];
      [close_button setHidden:YES];
      [close_button setEnabled:NO];
      [miniaturize_button setHidden:YES];
      [miniaturize_button setEnabled:NO];
      [zoom_button setHidden:YES];
      [zoom_button setEnabled:NO];
    });
  }
}
