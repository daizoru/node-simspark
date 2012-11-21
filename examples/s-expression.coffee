{inspect} = require 'util'

sexp = require './s-expression'

r1 = sexp "(GYR (n torso) (rt 0.01 0.07 0.46))"
console.log "test 1: " + inspect r1, no, 20, yes

r2 = sexp [ 
  'GYR'
  [ 'n', 'torso' ]
  [ 'rt', 0.01, 0.07, 0.46 ] 
]
console.log "test 2: " + inspect r2, no, 20, yes
