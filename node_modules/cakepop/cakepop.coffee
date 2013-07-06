# CakePop!
#
child_proc  = require 'child_process'

async       = require 'async'
colors      = require 'colors'
extend      = require 'deep-extend'
fileUtils   = require 'file-utils'

# Colors configuration
colors.setTheme
  silly:    'rainbow'
  input:    'grey'
  verbose:  'cyan'
  prompt:   'grey'
  info:     'green'
  data:     'grey'
  help:     'cyan'
  warn:     'yellow'
  debug:    'blue'
  error:    'red'

# Static utility methods.
#
# Can be used directly (not instance methods).
#
# @example Cakefile usage
#   utils = require("cakepop").utils
#   task "hello", "Print Hello World!", ->
#     utils.print "Hello World!"
#
class Utils

  # Log to console if non-empty string.
  #
  # @param [String] data String to print.
  #
  @print: (data) ->
    data = "[#{data.join ', '}]" if Array.isArray data
    data = (data ? "").toString().replace /[\r\n]+$/, ""
    console.log data if data

  # Print error of data message.
  #
  # @param [Object] err   Error.
  # @param [String] data  String to print.
  #
  @printCallback: (err, data) =>
    @print err ? data ? "Done.".info

  # Log failure and exit process.
  #
  # @param [String] msg Failure message.
  #
  @fail: (msg) ->
    process.stderr.write "#{msg}\n".error.bold if msg
    process.exit 1

  # Spawn with log pipes to stdout, stderr.
  #
  # @param [String]         cmd       Command / binary path.
  # @param [Array<String>]  args      Array of arguments to command.
  # @param [Object]         [opts]    (Optional) options.
  # @param [Function]       callback  Callback on process end (or null).
  #
  @spawn: (allArgs...) =>
    # Manually unpack arguments.
    argsLen   = allArgs.length
    cmd       = allArgs[0]
    args      = allArgs[1]
    opts      = if argsLen is 4 then allArgs[2] else {}
    callback  = if argsLen > 2 then allArgs[argsLen - 1] else null

    @print [cmd, args.join " "].join " "
    ps = child_proc.spawn cmd, args, opts
    ps.stdout.pipe process.stdout
    ps.stderr.pipe process.stderr
    ps.on "exit", callback if callback

  # Exec with log hooks to stdout, stderr.
  #
  # @param [String]   cmd       Command and arguments.
  # @param [Object]   [opts]    (Optional) options.
  # @param [Function] callback  Callback on process end (printCallback).
  #
  @exec: (allArgs...) =>
    # Manually unpack arguments.
    argsLen   = allArgs.length
    cmd       = allArgs[0]
    opts      = if argsLen is 3 then allArgs[1] else {}
    callback  = if argsLen > 1 then allArgs[argsLen - 1] else null
    callback  = @printCallback unless callback

    @print cmd
    child_proc.exec cmd, opts, (error, stdout, stderr) ->
      process.stderr.write stderr if stderr
      callback error, stdout.toString()

  # Return list of process id's matching egrep pattern.
  #
  # @param [String]   pattern   Egrep pattern.
  # @param [Function] callback  Callback on process end (printCallback).
  #
  @pids: (pattern, callback = @printCallback) =>
    cmd = "ps ax | egrep \"#{pattern}\" | egrep -v egrep || true"
    @exec cmd, (err, matches) ->
      matches = matches?.split("\n") ? []
      matches = (m.match(/\s*([0-9]+)/)[0] for m in matches when m)
      callback err, matches

  # Return list of files matching egrep pattern.
  #
  # @param [Array<String>]  dirs      Array of directories (default: ["./"]).
  # @param [String]         pattern   RegExp or string.
  # @param [Function]       callback  Callback on process end (printCallback).
  #
  @find: (dirs = ["./"], pattern, callback = @printCallback) =>
    finder = (dir, cb) =>
      pattern = new RegExp pattern if typeof pattern is 'string'
      paths   = []
      file    = new fileUtils.File dir
      filter  = (name, path) ->
        paths.push path if pattern.test name
        true

      file.list filter, (err) ->
        cb err, paths

    async.map dirs, finder, (err, results) =>
      # Merge arrays
      files = []
      if not err
        files = files.concat r for r in results

      callback err, files

# CoffeeScript build utilities.
#
# Instance methods (instantiate a class with optional configurations.)
#
# @example Cakefile usage
#   builder = new (require("cakepop").CoffeeBuild)()
#   task "source:build", "Build CoffeeScript to JavaScript.", ->
#     builder.build [
#       "foo.coffee"
#       { "src_dir": "lib_dir" }
#     ]
#
class CoffeeBuild

  # Constructor.
  #
  # Options are in the following (default) format:
  # @example
  #   coffee:
  #     bin:    "coffee"
  #     suffix: "coffee"
  #
  # @param  [Object]      opts          Options.
  # @option opts [String] coffee.bin    CoffeeScript binary path.
  # @option opts [String] coffee.suffix CoffeeScript file suffix.
  #
  constructor: (opts) ->
    defaults =
      coffee:
        bin:    "coffee"
        suffix: "coffee"

    @coffee = extend defaults.coffee, (opts?.coffee ? {})

  # Raw builder.
  # @private
  #
  _build: (paths, watch, callback) =>
    files     = (p for p in paths when typeof p is 'string')
    dirs      = (p for p in paths when typeof p isnt 'string')
    argsBase  = if watch then ["--watch"] else []

    build = (args, cb) =>
      Utils.spawn "#{@coffee.bin}", argsBase.concat(args), (code) ->
        err = if code is 0 then null else new Error "build failed"
        cb err

    buildDir = (pair, cb) ->
      src = Object.keys(pair)[0]
      dst = pair[src]
      build ["--compile", "--output", dst, src], cb

    cbs =
      buildFiles: (cb) ->
        return cb null if files.length < 1
        build ["--compile"].concat(files), cb

      buildDirs: (cb) ->
        async.forEach dirs, buildDir, cb

    async.parallel cbs, (err) ->
      callback err

  # Build CoffeeScript to JS on an array of files, directory paths.
  #
  # **Note**: The `paths` parameter takes an array of either string source
  # files or object source / destination object pairs.
  #
  # **Note**: The `coffee` binary must be installed separately and available
  # to a shell invocation.
  #
  # @example paths
  #   paths = [
  #     "foo.coffee"
  #     { "src_dir": "lib_dir" }
  #     "bar.coffee"
  #   ]
  #
  # @param  [Array<Object|String>] paths Array of file and source / dest dirs.
  # @param  [Function] callback Callback on process end (printCallback).
  #
  build: (paths = [], callback = Utils.printCallback) =>
    @_build paths, false, callback

  # Build CoffeeScript to JS with constant watching.
  #
  # **Note**: Takes over a terminal window until stopped (e.g., ctrl-c).
  #
  # **Note**: The `paths` parameter takes an array of either string source
  # files or object source / destination object pairs.
  #
  # **Note**: The `coffee` binary must be installed separately and available
  # to a shell invocation.
  #
  # @example paths
  #   paths = [
  #     "foo.coffee"
  #     { "src_dir": "lib_dir" }
  #     "bar.coffee"
  #   ]
  #
  # @param  [Array<Object|String>] paths Array of file and source / dest dirs.
  # @param  [Function] callback Callback on process end (printCallback).
  #
  watch: (paths = [], callback = Utils.printCallback) =>
    @_build paths, true, callback

# Style / static checker utilities.
#
# Instance methods (instantiate a class with optional configurations.)
#
# @example Cakefile usage
#   style = new (require("cakepop").Style)()
#   task "dev:coffeelint", "Run CoffeeScript style checks.", ->
#     style.coffeelint [
#       "foo.coffee"
#       "src_dir"
#     ]
#
class Style

  # Constructor.
  #
  # Options are in the following (default) format:
  # @example
  #   coffee:
  #     bin:    "coffeelint"
  #     suffix: "coffee"
  #     config: null
  #   js:
  #     bin:    "jshint"
  #     suffix: "js"
  #     config: null
  #
  # @param  [Object]      opts          Options.
  # @option opts [String] coffee.bin    coffeelint binary path.
  # @option opts [String] coffee.suffix CoffeeScript file suffix.
  # @option opts [String] coffee.config Path to coffeelint config file.
  # @option opts [String] js.bin        jshint binary path.
  # @option opts [String] js.suffix     JavaScript file suffix.
  # @option opts [String] js.config     Path to jshint config file.
  #
  constructor: (opts) ->
    defaults =
      coffee:
        bin:        "coffeelint"
        suffix:     "coffee"
        config:     null
        configOpt:  "--file"
        type:       "CoffeeScript"
        filesPat:   ["Cakefile"]
      js:
        bin:        "jshint"
        suffix:     "js"
        config:     null
        configOpt:  "--config"
        type:       "JavaScript"
        filesPat:   []

    @coffee = extend defaults.coffee, (opts?.coffee ? {})
    @js     = extend defaults.js,     (opts?.js ? {})

  # @private
  #
  _lint: (paths, cfg, callback) ->
    pattern = cfg.filesPat.concat([".*\\.#{cfg.suffix}"]).join "|"
    filesRe = new RegExp "(#{pattern})$"
    config  = if cfg.config then [cfg.configOpt, cfg.config] else []
    files   = (f for f in paths when filesRe.test f)
    dirs    = (f for f in paths when not filesRe.test f)

    cbs =
      searchDirs: (cb) ->
        # No directories to search.
        return cb null, [] if dirs.length < 1

        Utils.find dirs, filesRe, (err, dirFiles) ->
          cb err, dirFiles

      runLint: ["searchDirs", (cb, results) =>
        allFiles = files.concat(results?.searchDirs ? [])
        args = allFiles.concat(config)

        if allFiles.length < 1
          Utils.print  "No #{cfg.type} files found.\n".info
          cb null
          return

        Utils.spawn "#{cfg.bin}", args, (code) ->
          err = if code is 0 then null else new Error "checks failed"
          cb err
      ]

    async.auto cbs, (err) ->
      Utils.fail   "#{cfg.type} style checks failed. (#{err})" if err
      Utils.print  "#{cfg.type} style checks passed.\n".info
      callback err

  # Run coffeelint on an array of files, directory paths.
  #
  # **Note**: The `coffeelint` binary must be installed separately and
  # available to a shell invocation.
  #
  # @param  [Array<String>] paths     Array of file / directory paths.
  # @param  [Function]      callback  Callback on process end (printCallback).
  #
  coffeelint: (paths = [], callback = Utils.printCallback) =>
    @_lint paths, @coffee, callback

  # Run jshint on an array of files, directory paths.
  #
  # **Note**: The `jshint` binary must be installed separately and
  # available to a shell invocation.
  #
  # @param  [Array<String>] paths     Array of file / directory paths.
  # @param  [Function]      callback  Callback on process end (printCallback).
  #
  jshint: (paths = [], callback = Utils.printCallback) =>
    @_lint paths, @js, callback

module.exports =
  utils:        Utils
  CoffeeBuild:  CoffeeBuild
  Style:        Style
