Events = require '../events'
expect = require('chai').expect

describe 'Events', () ->
	events = null
	beforeEach () ->
		events = new Events()

	it 'should subscribe listener', (done) ->
		listener = (arg1, arg2) ->
			expect(arg1).to.equal 'arg1'
			expect(arg2).to.equal 'arg2'
			done()

		events.on 'foo', listener
		events.emit 'foo', 'arg1', 'arg2'

	it 'should get listeners', () ->
		listener = () ->
		events.on 'foo', listener
		expect(events.listeners('foo')).to.have.length 1

	it 'should remove listeners', () ->
		listener = () ->
		events.on 'foo', listener
		events.removeListener 'foo', listener
		expect(events.listeners('foo')).to.have.length 0