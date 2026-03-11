{...}: {
  system.defaults = {
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      ApplePressAndHoldEnabled = false;
      _HIHideMenuBar = true;
      NSWindowShouldDragOnGesture = true;
    };

    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv";
      FXEnableExtensionChangeWarning = false;
    };

    dock = {
      autohide = true;
      autohide-delay = 1000.0;
      autohide-time-modifier = 0.0;
      show-recents = false;
      wvous-br-corner = 1;
      showMissionControlGestureEnabled = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
    };

    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = false;
    };

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

    WindowManager = {
      EnableStandardClickToShowDesktop = false;
      GloballyEnabled = false;
      EnableTopTilingByEdgeDrag = false;
      EnableTilingByEdgeDrag = false;
    };

    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "28" = {enabled = 0;};
          "29" = {enabled = 0;};
          "30" = {enabled = 0;};
          "31" = {enabled = 0;};
          "64" = {enabled = 0;};
          "65" = {enabled = 0;};
          "184" = {enabled = 0;};
        };
      };
    };
  };
}
