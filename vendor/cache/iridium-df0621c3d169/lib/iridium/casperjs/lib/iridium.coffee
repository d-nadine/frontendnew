# This file defines the Iridium object. It holds configuration
# need for tests. It also defines a new Casper object to use
# for integration tests. It also makes two values available 
# globally through the Iridum object:
#
# 1. The Iridium load path (core files)
# 2. The test support load path (app files)

fs = require('fs')
colorizer = require('colorizer')
logger = requireExternal('iridium/logger').create()

class IridiumCasper extends require('casper').Casper
  formatBacktrace: (trace) ->
    formatted = []

    for e in trace 
      if e.file
        line = "#{e.file}:#{e.line}"
      else
        line = "(casperjs)"

      if e.function
        line = "#{line} in #{e['function']}" 

      formatted.push line

    formatted

  appURL: "http://localhost:7777/"

  # Warning should blow up the process.
  # There is no reason why any code should trigger
  # a warning
  warn: (message) ->
    console.abort message

  die: (message, status) ->
    @test.fail message

  constructor: (options) ->
    super options

    @logger = logger

    # Hook remote console to this one
    @on 'remote.message', (msg) ->
      console.log msg

    # Disable colorizing
    cls = 'Dummy'
    @options.colorizerType = cls
    @colorizer = colorizer.create(cls)

    @on 'page.error', (error, trace) ->
      result = {}
      result.name = "Uncaught error"
      result.message = error
      result.backtrace = casper.formatBacktrace(trace)
      result.error = true
      logger.message result

    # Redfine the runTest method to emit an event we can list to
    @test.runTest = (testFile) ->
      @emit("test.started", testFile)
      @running = true; # this.running is set back to false with done()
      @exec(testFile)

    # Patch the test.done method to emit the done event
    # so we can print test results in real time.
    # This functionality should make it into the 1.0 release.
    #
    # It was added in this commit: 
    # https://github.com/n1k0/casperjs/commit/4eee81406c1e672eec58ca8c80e336ab2863e988
    @test.done = ->
      return unless @running
      @emit('test.done')
      @running = false

    # More hacks. This patch makes failed assertions raise exceptions
    # instead of just being accepted and continuing. Seriously...
    # I have to include this. Without this patch tests will continue
    # to run even if an assertion fails. 
    #
    # I would've really like to simply alias or call super but that's
    # not possible. Aliasing doesn't work because it changes the scope
    # and calls to "this" are not correct. I can't call super because
    # of the way casper builds the test object. That leaves me only
    # one option but to copy the code from the source :/
    @test.processAssertionResult = (result) ->
      if result.success == true
        eventName = 'success'
        style = 'INFO'
        status = @options.passText
        @testResults.passed++
      else
        eventName = 'fail'
        style = 'RED_BAR'
        status = @options.failText
        @testResults.failed++

      message = result.message || result.standard
      casper.echo([@colorize(status, style), @formatMessage(message)].join(' '))
      @emit(eventName, result)

      # blow up if an assertion failed and it's not an exception
      # casper passes exceptions through this function as "uncaughtError"
      # why..because...I have no idea. An exception is thrown here
      # that will propogate up to the error event. Skip forwarding
      # that error to iridium then the test suite will stop
      if !result.success && result.type != 'uncaughtError'
        throw "ASSERTION FAILED"

      result

    currentTest = {}
    startTime = null

    # Record that a new test and started and wipe state
    @test.on 'test.started', (testFile) ->
      startTime = (new Date()).getTime()
      currentTest = {}
      currentTest.assertions = 0
      currentTest.name = testFile
      currentTest.file = testFile

    # This doesn't mean that the entire test passed, but simply one
    # single assertion was correct
    @test.on 'success', ->
      currentTest.assertions++

    # remove the stock functionality so we can replace with ours
    @removeAllListeners(['error'])

    #The test raised an exception
    @on 'error', (error, trace) ->
      # we only want to report "real" exceptions as errors
      # I mean things like calling undefined methods and other
      # things. This error is raised when an assertion fails.
      return if error == "ASSERTION FAILED"

      currentTest.error = true
      currentTest.backtrace = @formatBacktrace(trace)
      currentTest.message = error
      @test.done()

    @test.on 'fail', (failure) -> 
      currentTest.assertions++
      currentTest.failed = true
      currentTest.message = failure.type + ": " + (failure.message || failure.standard || "(no message was entered)")
      currentTest.backtrace = [failure.file]
      @done()

    @test.on 'test.done', =>
      # don't report results coming from the integration test that runs unit tests
      return if currentTest.name.match(/lib\/iridium\//)

      currentTest.time = (new Date().getTime()) - startTime

      @logger.message currentTest

    @test.on 'tests.complete', =>
      @exit()

class Iridium
  casper: (options) ->
    absolutePaths = []
    absolutePaths.push fs.pathJoin(@root, "iridium", "qunit.js")

    for file in ['logger', 'console', 'qunit_adapter']
      absolutePaths.push fs.pathJoin(@root, "iridium", "#{file}.coffee")

    options ||= {}

    options.clientScripts = absolutePaths.concat(@supportFiles)

    new IridiumCasper(options)

exports.Iridium = Iridium

exports.casper = (options) ->
  (new Iridium).casper(options)
