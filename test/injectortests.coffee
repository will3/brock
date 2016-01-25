expect = require('chai').expect

describe 'Injector', () ->
	injector = null
	beforeEach () ->
		injector = require('../injector')()

	it 'should bind value', () ->
		injector.value 'foo', 'bar'
		expect(injector.get 'foo').to.equal 'bar'

	it 'should bind factory', () ->
		injector.factory 'foo', () ->
			return 'bar'
		expect(injector.get('foo')).to.equal('bar')

	it 'should bind type', () ->
		class Foo
		injector.service 'foo', Foo
		instance = injector.get 'foo'
		expect(instance instanceof Foo).to.be.true

	it 'should inject dependencies for service', () ->
		injector.value 'bar', 'value'
		injector.service 'foo', ['bar', (bar) ->
			@value = bar
		]
		instance = injector.get 'foo'
		expect(instance.value).to.equal 'value'

	it 'should inject dependencies for factory', () ->
		injector.value 'bar', 'value'
		injector.factory 'foo', ['bar', (bar) -> 
			return value: bar
		]
		instance = injector.get 'foo'
		expect(instance.value).to.equal 'value'