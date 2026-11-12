; extends

; The jinja parser leaves the non-jinja text as `content` nodes. Parse those as
; the template's base language (README.md.jinja -> markdown, config.yaml.j2 ->
; yaml). combined merges the fragments between {% %}/{{ }} into one tree.
; The parser also reads `##` as a jinja line comment, which swallows markdown
; headings, so everything except real {# #} comments goes to the base language.
([
  (content)
  (comment)
] @injection.content
  (#not-lua-match? @injection.content "^{#")
  (#set-template-base-language!)
  (#set! injection.combined))
