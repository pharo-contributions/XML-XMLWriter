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
