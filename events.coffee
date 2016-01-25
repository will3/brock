_ = require 'lodash'

class Events
	constructor: () ->
		@_listeners = {}

	on: (event, callback) ->
		if !@_listeners[event]?
			@_listeners[event] = []
		@_listeners[event].push callback

	emit: (event, args...) ->
		callbacks = @_listeners[event] || []
		callbacks.forEach (callback) ->
			callback.apply null, args

	removeListener: (event, callback) ->
		if @_listeners[event]?
			_.pull @_listeners[event], callback

		if callback is undefined
			@_listeners[event] = []

	listeners: (event) ->
		return @_listeners[event] || []

module.exports = Events