fs = require 'fs'
Snockets = require 'snockets'

NAME = 'mikes-modal'
INPUT_FILE = "src/#{NAME}.js.coffee"
OUTPUT_FILE = "lib/#{NAME}.min.js"

task 'build', 'Build src/ from lib/', ->
  snockets = new Snockets()
  js = snockets.getConcatenation INPUT_FILE, async: false, minify: true
  fs.writeFileSync OUTPUT_FILE, js

task 'clean', "remove #{OUTPUT_FILE}", ->
  fs.unlinkSync OUTPUT_FILE