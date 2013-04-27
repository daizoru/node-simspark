{inspect} = require 'util'

isArray     = (obj) -> Array.isArray obj
isString    = (obj) -> !!(obj is '' or (obj and obj.charCodeAt and obj.substr))

readString = (p) ->
  p.replace(/\s+/g, ', ').replace(/\)\(/g, '), (').replace(/\(/g, '[').replace(/\)/g, ']').replace(new RegExp("([a-zA-Z_][a-zA-Z0-9_]*)","gi"), "\"$1\"")
  
module.exports = S = (p) ->
  if isString p
    eval readString p
  else
    if isArray p
      s = for e in p
        if isArray e then S(e) else "#{e}"
      "(#{s.join ' '})"