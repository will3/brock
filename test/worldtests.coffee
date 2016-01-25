expect = require('chai').expect

describe 'World', () ->
	world = null

	beforeEach () ->
		world = require('../world')()

	it 'should set entity id', () ->
		object = {}
		component = {}
		world.attach object, component
		expect(object._entityId).to.exist
		expect(component._componentId).to.exist

	it 'should not override entity id', () ->
		object = 
			_entityId: 'foo'
		component = {}
		world.attach object, component
		expect(object._entityId).to.equal 'foo'

	it 'should not override component id', () ->
		object = {}
		component = 
			_componentId: 'foo'
		world.attach object, component
		expect(component._componentId).to.equal 'foo'

	it 'should traverse attached components', () ->
		object = {}
		component = {}
		world.attach object, component
		count = 0
		world.traverse (c) ->
			count++

		expect(count).to.equal(1)
