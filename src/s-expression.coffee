{inspect} = require 'util'

isArray     = (obj) -> Array.isArray obj
isString    = (obj) -> !!(obj is '' or (obj and obj.charCodeAt and obj.substr))

readString = (p) ->
  p.replace(/\(/g, '[').replace(/\)/g, ']').replace(/\s+/g, ',').replace(new RegExp("([a-zA-Z]+)","gi"), "\"$1\"")

module.exports = S = (p) ->
  if isString p
    eval readString p
  else
    if isArray p
      s = for e in p
        if isArray e then S(e) else "#{e}"
      "(#{s.join ' '})"