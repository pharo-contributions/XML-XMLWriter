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
XMLWriterTest >> testAttributes [
	| writer tag |

	writer := XMLWriter new.
	tag := writer  tag: 'outer' attributes: (Array with: 'first' -> 'one').
	self
		assert: tag hasAttributes;
		assert: (tag attributeAt: 'first') = 'one';
		assert: (tag attributeAt: 'second' put: 'two') = 'two';
		assert: (tag attributeAt: 'third' ifAbsentPut: ['three']) = 'three';
		assert: (tag attributeAt: 'fourth' ifAbsent: [true]);
		assert: (tag attributeAt: 'fourth') isEmpty;
		assert: (tag attributes at: 'fourth') isEmpty;
		deny: (tag includesAttribute: 'fourth').
	tag with: [
		writer
			tag: 'inner'
			attributes: (Dictionary with: 'fourth' -> 'four')
			with: 'test'].
	self assert:
		writer contents =
			'<outer first="one" second="two" third="three"><inner fourth="four">test</inner></outer>'.
]

{ #category : #tests }
XMLWriterTest >> testContentEscaping [
	| writer |

	(writer := XMLWriter new)
		tag
			name: 'test';
			attributeAt: 'escaped' put: '& " < >';
			with: '& " < >'.
	self assert:
		writer contents =
			'<test escaped="&amp; &quot; &lt; &gt;">&amp; &quot; &lt; &gt;</test>'.

	((writer := XMLWriter new)
		isEscaping: false;
		tag)
			name: 'test';
			attributeAt: 'unescaped' put: '& " < >';
			with: '& " < >'.
	self assert: writer contents = '<test unescaped="& " < >">& " < ></test>'.
]

{ #category : #tests }
XMLWriterTest >> testEntityValueEscaping [
	| writer |

	(writer := XMLWriter new)
		entityDeclaration
			name: 'test';
			replacement: '% " < >';
			write.
	self assert: writer contents = '<!ENTITY test "&#37; &#34; < >">'.

	((writer := XMLWriter new)
		isEscaping: false;
		entityDeclaration)
			name: 'test';
			replacement: '% " < >';
			write.
	self assert: writer contents = '<!ENTITY test "% " < >">'.

]

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

{ #category : #tests }
XMLWriterTest >> testStartingAndFinishing [
	| writer outer inner |

	writer := XMLWriter new.

	(outer := writer tag: 'outer')
		attributeAt: 'test' put: 'value';
		startWriting.

	(inner := writer tag: 'inner')
		startWriting.
	writer string: 'test'.
	inner finishWriting.

	self assert: writer contents = '<outer test="value"><inner>test</inner></outer>'.
]

{ #category : #tests }
XMLWriterTest >> testSystemAndPublicIDs [
	| writer |

	(writer := XMLWriter new)
		doctype
			root: 'test';
			publicID: 'public"ID';
			systemID: 'system"ID'''. "contains double and single quote"

	"IDs are single quoted because they contain a double quote"
	self assert: writer contents = '<!DOCTYPE test PUBLIC ''public"ID'' ''system"ID''>'
]

{ #category : #tests }
XMLWriterTest >> testXmlnsDeclarations [
	| writer tag |

	writer := XMLWriter new.
	tag := writer  tag: 'test'.
	tag xmlnsDeclarations: (Array with: '' -> 'default1' with: 'ns1' -> 'first').
	self
		assert: tag xmlns = 'default1';
		assert: (tag xmlnsAt: '') = 'default1';
		assert: (tag xmlns: 'default2') = tag;
		assert: tag xmlns = 'default2';
		assert: (tag xmlnsAt: 'ns1') = 'first';
		assert: (tag xmlnsAt: 'ns2' put: 'second') = 'second';
		assert: (tag xmlnsAt: 'ns3' ifAbsentPut: ['third']) = 'third';
		assert: (tag xmlnsAt: 'ns4' ifAbsent: [true]);
		assert: (tag xmlnsAt: 'ns4') isEmpty;
		assert: (tag xmlnsDeclarations at: 'ns4') isEmpty;
		assert:
			writer contents =
				'<test xmlns="default2" xmlns:ns1="first" xmlns:ns2="second" xmlns:ns3="third" />'.
]
