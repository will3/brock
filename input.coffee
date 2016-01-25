_ = require 'lodash'
keycode = require 'keycode'

class Input
	constructor: (@element) ->
		@state = new InputState
		@listeners = {}
		@lastMousedowns = {}
		@clickTime = 150

	start: () ->
		@element.addEventListener 'mousedown', @listeners.mousedown = (e) => 
			@state.mousedowns.push e.button
			if not _.includes @state.mouseholds, e.button
				@state.mouseholds.push e.button
			@lastMousedowns[e.button] = new Date().getTime()
			return
		@element.addEventListener 'mouseup', @listeners.mouseup = (e) => 
			@state.mouseups.push e.button
			_.pull @state.mouseholds, e.button
			lastMousedown = @lastMousedowns[e.button]
			if lastMousedown?
				diff = new Date().getTime() - lastMousedown
				@state.mouseclicks.push e.button if diff < @clickTime
			return
		@element.addEventListener 'mousemove', @listeners.mousemove = (e) => 
			@state.mouseX = e.clientX
			@state.mouseY = e.clientY
			return
		@element.addEventListener 'mouseenter', @listeners.mouseenter = () => 
			@state.mouseenter = true
			@state.keyholds = []
			@state.mouseholds = []
			return
		@element.addEventListener 'mouseleave', @listeners.mouseleave = () => 
			@state.mouseleave = true
			@state.keyholds = []
			@state.mouseholds = []
			return
		@element.addEventListener 'keydown', @listeners.keydown = (e) =>
			if not _.includes @state.keyholds, keycode e
				@state.keyholds.push keycode e
			@state.keydowns.push keycode e
			return
		@element.addEventListener 'keyup', @listeners.keyup = (e) =>
			@state.keyups.push keycode e
			_.pull @state.keyholds, keycode e
			return
		return

	lateTick: () ->
		@state.clearTemporalStates()
		return

	dispose: () ->
		@element.removeEventListener 'mousedown', @listeners.mousedown
		@element.removeEventListener 'mouseup', @listeners.mouseup
		@element.removeEventListener 'mousemove', @listeners.mousemove
		@element.removeEventListener 'mouseenter', @listeners.mouseenter
		@element.removeEventListener 'mouseleave', @listeners.mouseleave
		@element.removeEventListener 'keydown', @listeners.keydown
		@element.removeEventListener 'keyup', @listeners.keyup
		return

class InputState
	constructor: () ->
		@mouseX = 0
		@mouseY = 0
		@mousedowns = []
		@mouseups = []
		@mouseholds = []
		@mouseenter = false
		@mouseleave = false
		@keydowns = []
		@keyups = []
		@keyholds = []
		@mouseclicks = []

	mouseDown: (button) ->
		return @mousedowns.length > 0 if button is undefined
		return _.includes @mousedowns, button

	mouseUp: (button) ->
		return @mouseups.length > 0 if button is undefined
		return _.includes @mouseups, button

	mouseHold: (button) ->
		return @mouseholds.length > 0 if button is undefined
		return _.includes @mouseholds, button

	mouseClick: (button) ->
		return @mouseclicks.length > 0 if button is undefined
		return _.includes @mouseclicks, button

	keyDown: (key) ->
		return _.includes @keydowns, key

	keyUp: (key) ->
		return _.includes @keyups, key

	keyHold: (key) ->
		return _.includes @keyholds, key

	clearTemporalStates: () ->
		@mousedowns = []
		@mouseups = []
		@mouseenter = false
		@mouseleave = false
		@keydowns = []
		@keyups = []
		@mouseclicks = []
		return

module.exports = () ->
	args = Array.prototype.slice.call arguments
	new(Function.prototype.bind.apply(
		Input,
		[null].concat args
	))