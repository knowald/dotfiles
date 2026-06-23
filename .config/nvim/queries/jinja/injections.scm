; extends

; The jinja parser leaves the non-jinja text as `content` nodes. Parse those as
; the template's base language so e.g. config.yaml.j2 highlights both yaml and
; jinja. combined merges the fragments between {% %}/{{ }} into one yaml tree.
((content) @injection.content
  (#set! injection.language "yaml")
  (#set! injection.combined))
