{theme, ...}: let
  c = theme.colors;
in {
  programs.bat = {
    enable = true;
    config = {
      theme = "flexoki-dark";
      style = "numbers";
    };
  };

  xdg.configFile."bat/themes/flexoki-dark.tmTheme".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>name</key>
        <string>flexoki-dark</string>
        <key>semanticClass</key>
        <string>theme.dark.flexoki</string>
        <key>colorSpaceName</key>
        <string>sRGB</string>
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
              <key>lineHighlight</key>
              <string>${c.bg1}</string>
              <key>selection</key>
              <string>${c.bg2}</string>
              <key>activeGuide</key>
              <string>${c.bg2}</string>
              <key>gutterForeground</key>
              <string>${c.muted}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Base text</string>
            <key>scope</key>
            <string>text, source, variable.other.readwrite, punctuation.definition.variable</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.text}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Punctuation</string>
            <key>scope</key>
            <string>punctuation, punctuation.definition, punctuation.separator, punctuation.terminator</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.subtext1}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Comments</string>
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
            <string>Strings</string>
            <key>scope</key>
            <string>string, punctuation.definition.string</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.green}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Escapes and regex</string>
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
            <string>Numbers and booleans</string>
            <key>scope</key>
            <string>constant.numeric, constant.language.boolean, constant.language.false, constant.language.true, variable.other.constant, entity.name.constant</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.orange}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Keywords and storage</string>
            <key>scope</key>
            <string>keyword, keyword.operator.word, storage.type, storage.modifier, punctuation.definition.keyword</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.purple}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Operators</string>
            <key>scope</key>
            <string>keyword.operator, punctuation.accessor</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.subtext1}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Functions</string>
            <key>scope</key>
            <string>entity.name.function, support.function, support.function.misc, variable.function, meta.function-call.method</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.blue}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Types and classes</string>
            <key>scope</key>
            <string>entity.name.class, entity.other.inherited-class, support.class, entity.name.type, support.type, storage.type</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.yellow}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Parameters</string>
            <key>scope</key>
            <string>variable.parameter, variable.parameter.name, meta.function.parameters</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.text}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Built-ins and language constants</string>
            <key>scope</key>
            <string>constant.language, support.function.builtin</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.red}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Diff inserted</string>
            <key>scope</key>
            <string>markup.inserted.diff</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.green}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Diff deleted</string>
            <key>scope</key>
            <string>markup.deleted.diff</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>${c.red}</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>Invalid</string>
            <key>scope</key>
            <string>invalid, invalid.illegal</string>
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
}
