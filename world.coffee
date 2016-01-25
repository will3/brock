_ = require 'lodash'

guid = () ->
	s4 = () ->
		Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1)

  s4() + s4() + '-' + s4() + '-' + s4() + '-' +
    s4() + '-' + s4() + s4() + s4();

class World
	constructor: () ->
		@scene = {}

	attach: (object, component) ->
		if object._entityId is undefined
			object._entityId = guid()

		if component._componentId is undefined
			component._componentId = guid()

		components = @scene[object._entityId]
		if components is undefined
			components = @scene[object._entityId] = []

		components.push component
		return

	dettach: (object, component) ->
		return if object._entityId is undefined
		components = @scene[object._entityId]
		return if component is undefined

		component.dispose() if component.dispose isnt undefined
		_.pull components, component

		if components.length is 0
			delete @scene[object._entityId]
		return

	getComponents: (object) ->
		return @scene[object._entityId] || []

	getComponent: (object, type) ->
		components = @getComponents object

		return _.find components, (c) ->
			return c._type == type

	traverse: (callback) ->
		for id, components of @scene
			components.forEach (c) ->
				callback(c)
		return

module.exports = () ->
	new World()