{pkgs, theme, ...}: let
  c = theme.colors;

  flexokiDarkTmTheme = pkgs.writeText "bat-flexoki-dark.tmTheme" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>name</key>
      <string>flexoki-dark</string>
      <key>settings</key>
      <array>
        <dict>
          <key>settings</key>
          <dict>
            <key>background</key>
            <string>${c.black}</string>
            <key>foreground</key>
            <string>${c.text}</string>
            <key>caret</key>
            <string>${c.text}</string>
            <key>selection</key>
            <string>${c.bg2}</string>
            <key>lineHighlight</key>
            <string>${c.bg1}</string>
            <key>invisibles</key>
            <string>${c.uiMuted}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Comment</string>
          <key>scope</key>
          <string>comment, punctuation.definition.comment</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.muted}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Keyword</string>
          <key>scope</key>
          <string>keyword, keyword.control, keyword.operator.word</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.purple}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Storage</string>
          <key>scope</key>
          <string>storage, storage.type, storage.modifier</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.purple}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Type</string>
          <key>scope</key>
          <string>entity.name.type, entity.name.class, support.type, support.class</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.yellow}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Function</string>
          <key>scope</key>
          <string>entity.name.function, support.function, meta.function-call, variable.function</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.blue}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Function Parameter</string>
          <key>scope</key>
          <string>variable.parameter</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.text}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Variable</string>
          <key>scope</key>
          <string>variable, support.variable</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.text}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Constant</string>
          <key>scope</key>
          <string>constant, constant.language, constant.character, support.constant</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.cyan}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>String</string>
          <key>scope</key>
          <string>string, string.quoted, string.template</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.green}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Escape</string>
          <key>scope</key>
          <string>constant.character.escape, string.regexp, string.other.regex</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.cyan}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Number and Boolean</string>
          <key>scope</key>
          <string>constant.numeric, constant.language.boolean</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.orange}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Operators</string>
          <key>scope</key>
          <string>keyword.operator, punctuation.separator, punctuation.terminator</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.subtext1}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Punctuation</string>
          <key>scope</key>
          <string>punctuation.definition, meta.brace, meta.delimiter</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.subtext1}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Tag</string>
          <key>scope</key>
          <string>entity.name.tag, meta.tag, support.class.component</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.blue}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Attribute</string>
          <key>scope</key>
          <string>entity.other.attribute-name</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.cyan}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Markdown Headings</string>
          <key>scope</key>
          <string>markup.heading, punctuation.definition.heading</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.blue}</string>
            <key>fontStyle</key>
            <string>bold</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Markdown Emphasis</string>
          <key>scope</key>
          <string>markup.bold, markup.italic</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.text}</string>
            <key>fontStyle</key>
            <string>bold</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Markdown Code</string>
          <key>scope</key>
          <string>markup.inline.raw, markup.fenced_code, markup.raw</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.green}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Diff Added</string>
          <key>scope</key>
          <string>markup.inserted, meta.diff.header.from-file</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.green}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Diff Changed</string>
          <key>scope</key>
          <string>markup.changed</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.yellow}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Diff Removed</string>
          <key>scope</key>
          <string>markup.deleted, meta.diff.header.to-file</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.red}</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Link</string>
          <key>scope</key>
          <string>markup.underline.link, string.other.link</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.cyan}</string>
            <key>fontStyle</key>
            <string>underline</string>
          </dict>
        </dict>
        <dict>
          <key>name</key>
          <string>Invalid</string>
          <key>scope</key>
          <string>invalid</string>
          <key>settings</key>
          <dict>
            <key>foreground</key>
            <string>${c.black}</string>
            <key>background</key>
            <string>${c.red}</string>
          </dict>
        </dict>
      </array>
    </dict>
    </plist>
  '';

  flexokiDarkThemeDir = pkgs.runCommand "bat-flexoki-dark-theme" {} ''
    mkdir -p "$out"
    cp "${flexokiDarkTmTheme}" "$out/flexoki-dark.tmTheme"
  '';
in {
  programs.bat = {
    enable = true;
    themes = {
      flexoki-dark = {
        src = flexokiDarkThemeDir;
        file = "flexoki-dark.tmTheme";
      };
    };
    config = {
      theme = "flexoki-dark";
      style = "numbers,changes,header";
    };
  };
}
