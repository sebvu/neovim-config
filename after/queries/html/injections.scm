; inherits: html

; Match script tags with type="text/babel" and inject javascript (or tsx/jsx)
(script_element
  (tag_name) @tag
  (#eq? @tag "script")
  attribute: (attribute
    (attribute_name) @attr_name
    (#eq? @attr_name "type")
    (quoted_attribute_value
      (attribute_value) @val
      (#eq? @val "text/babel")))
  content: (raw_text) @injection.content
  (#set! injection.language "tsx")) ; or "tsx" if you use JSX syntax
