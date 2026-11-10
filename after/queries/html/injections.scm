; inherits: html

; The html grammar declares no fields for attribute/raw_text, and attributes live
; under start_tag, not directly under script_element. Getting this wrong makes the
; whole query fail to compile, which throws out of every markdown parse that
; injects html (chat buffers included).

; <script type="text/babel">...</script> -> inject tsx. The runtime html_tags query
; turns type="foo/bar" into the language after the slash, so text/jsx already
; resolves to jsx; text/babel resolves to the unregistered language "babel" and is
; silently dropped. Only the latter needs handling.
((script_element
  (start_tag
    (attribute
      (attribute_name) @attr_name
      (#eq? @attr_name "type")
      (quoted_attribute_value
        (attribute_value) @val
        (#eq? @val "text/babel"))))
  (raw_text) @injection.content)
  (#set! injection.language "tsx"))
