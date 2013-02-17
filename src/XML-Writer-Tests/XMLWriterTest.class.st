"
A simple test case class. 
Please add more tests to it!
"
Class {
	#name : #XMLWriterTest,
	#superclass : #TestCase,
	#category : #'XML-Writer-Tests'
}

{ #category : #tests }
XMLWriterTest >> testExampleUser [

	| writer  |
	writer := XMLWriter new.
	writer
		enablePrettyPrinting;
		xml;
		comment: 'an example'.
	writer tag
		name: 'example:user';
		xmlnsAt: 'example' put: 'urn://example';
		with: [
			writer
				tag: 'username' with: 'jsmith';
				tag: 'real-name' with: 'John Smith';
				tag: 'age' with: '25';
				tag: 'id' with: '101'].
	self assert: writer contents = '<?xml version="1.0" encoding="UTF-8"?>
<!--an example-->
<example:user xmlns:example="urn://example">
    <username>jsmith</username>
    <real-name>John Smith</real-name>
    <age>25</age>
    <id>101</id>
</example:user>'
]

{ #category : #tests }
XMLWriterTest >> testSimpleExample [

	| writer  |
	writer := XMLWriter new.
	writer tag
			name: 'emptyTag';
			attributeAt: 'a' put: 'one';
			write.
			
	self assert: writer contents  =  '<emptyTag a="one" />'
]

{ #category : #tests }
XMLWriterTest >> testSimpleExampleWithWriteWith [

	| res |
	res :=  XMLWriter new
		writeWith: [:writer |
			writer tag
				name: 'emptyTag';
				attributeAt: 'a' put: 'value'].
		
	self assert:  res contents  =  '<emptyTag a="value" />'
]
