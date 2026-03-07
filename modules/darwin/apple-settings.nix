{...}: {
  system.defaults = {
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      AppleShowAllExtensions = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      ApplePressAndHoldEnabled = false;
    };

    finder = {
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferedViewStyle = "Nlsv";
      _FXSortFoldersFirst = true;
      FXEnableExtensionChangeWarning = false;
    };

    dock = {
      autohide = true;
      autohide-delay = 1000.0;
      autohide-time-modifier = 0.0;
    };

    trackpad = {
      Clicking = true;
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
