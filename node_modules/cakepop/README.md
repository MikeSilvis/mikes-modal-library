CakePop!
========
[CakePop][cakepop] is a set of Node.js build helpers and CoffeeScript Cake
extensions. It provides various utility wrappers for bash shell commands and
other Node.js binary process executions.

Notwithstanding it's CoffeeScript-friendliness, CakePop runs off of real
JavaScript without CoffeeScript dependencies, and is thus appropriate for
use in pure JavaScript code (e.g., with Jakefiles).

[api]: http://ryan-roemer.github.com/node-cakepop
[cakepop]: https://github.com/ryan-roemer/node-cakepop
[cakefile]: https://github.com/ryan-roemer/node-cakepop/blob/master/Cakefile

See the [API documentation][api] for full information, or CakePop's own
[`Cakefile`][cakefile] for some example usage.

Documentation is presently in source comments in `cakepop.coffee`. While not
ideal, the source is quite readable. There will be a more friendly version in
the future.

**Warning**: The library is currently undergoing a lot of restructuing and
change, so expect the API to drastically change until things settle down.
Breaking changes will be versioned (with git tags and in NPM), but that's
about it for now.

Installation
============
To get the library:

    $ npm install cakepop

CakePop does **not** install dependencies for tasks that are shell-invoked,
to keep the library small and let the user install the proper version of a
library (like `coffeelint`). So, you will need manual installations for the
following:

* CoffeeScript Build Tasks: `npm install coffee-script`
* Coffeelint: `npm install coffeelint`

Basic Usage
===========
Here are some common `Cakefile` tasks that CakePop can help with.

Exec / spawn a bash process:

    utils = require("cakepop").utils

    task "hello1", "Exec 'hello world'", ->
      utils.exec "echo Hello World"

    task "hello2", "Spawn 'hello world'", ->
      utils.spawn "echo", ["Hello World"]

Build CoffeeScript files to JavaScript:

    builder = new (require("cakepop").CoffeeBuild)()

    task "source:build", "Build CoffeeScript to JavaScript.", ->
      builder.build [
        "foo.coffee"
        { "src_dir": "dest_dir" }
      ]

See the API documentation for more.


License
=======
CakePop is Copyright 2012 Ryan Roemer. Released under the MIT License.
