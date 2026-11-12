; extends

; @comment.jinja is cleared in lua/plugins/treesitter.lua because the parser
; also reads `##` lines (markdown headings, yaml comments) as comments. Only
; real {# #} comments keep the comment highlight.
((comment) @comment.block
  (#lua-match? @comment.block "^{#"))
