fs = require 'fs'
{exec} = require 'child_process'
Snockets = require 'snockets'

FILE = 'mikes-modal'
JS_INPUT_FILE = "src/#{FILE}.js.coffee"
JS_OUTPUT_FILE = "lib/#{FILE}.min.js"
CSS_INPUT_FILE = "src/#{FILE}.css.scss"
CSS_OUTPUT_FILE = "lib/#{FILE}.css"


task 'build', 'Build src/ from lib/', (opt) ->
  snockets = new Snockets()
  js = snockets.getConcatenation JS_INPUT_FILE , async: false, minify: true
  fs.writeFileSync JS_OUTPUT_FILE, js
  console.log "build #{JS_OUTPUT_FILE}"
  system "sass #{CSS_INPUT_FILE} #{CSS_OUTPUT_FILE}", (err) =>
    console.log "build #{CSS_OUTPUT_FILE}" unless opt.silent

task 'clean', "remove #{JS_OUTPUT_FILE}", ->
  fs.unlinkSync JS_OUTPUT_FILE

system = (cmd, fn) ->
  exec cmd, (err, stdout, stderr) =>
    return fn(err) if err
    return fn(stderr) if stderr
    return fn(null, stdout)
