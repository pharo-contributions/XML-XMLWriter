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
XMLWriterTest >> testCDataSections [
	| writer |

	(writer := XMLWriter new)
		tag: 'cdata'
		with: [
			writer cdata: '<escaped name="&value;" />'.
			writer cdata with: [
				writer tag
					name: 'escaped';
					with: [writer & 'value']]].

	self assert:
		writer contents =
			('<cdata>',
			'<![CDATA[<escaped name="&value;" />]]>',
			'<![CDATA[<escaped>&value;</escaped>]]>',
			'</cdata>').
]

{ #category : #tests }
XMLWriterTest >> testCanonicalDTDs [
	| writer |

	(writer := XMLWriter new)
		isCanonical: true;
		comment: 'start of dtd'.
	writer doctype
		root: 'element';
		systemID: 'doc.dtd';
		with: [
			writer comment: 'ignored'.
			writer elementDeclaration
				name: 'ignored';
				contentModel: 'EMPTY'.
			writer entityDeclaration
				name: 'ignored';
				replacement: 'ignored'.
			writer attributeDeclaration
				element: 'ignored';
				attribute: 'ignored';
				type: 'CDATA';
				defaultPragma: '#REQUIRED'.
			writer notationDeclaration
				name: 'external';
				systemID: 'external.txt'.
			writer pi
				target: 'ignored';
				data: 'ignored'].
	writer comment: 'end of dtd'.

	self assert: writer contents = '<!--start of dtd--><!--end of dtd-->'.
]

{ #category : #tests }
XMLWriterTest >> testCanonicalTags [
	| writer |

	(writer := XMLWriter new)
		isCanonical: true;
		comment: 'tags'.
	(writer tag: 'tags')
		attributeAt: 'c' put: '3';
		attributeAt: 'a' put: '1';
		attributeAt: 'b' put: '2';
		xmlnsAt: 'b' put: 'ns2';
		xmlnsAt: 'a' put: 'ns1';
		xmlns: 'default';
		with: [
			writer
				tag: 'cdata'
				with: [writer cdata: '<escaped name="&value;" />'].
			writer
				tag: 'empty'
				with: nil].

	self assert:
		writer contents =
			('<!--tags-->',
			'<tags xmlns="default" xmlns:a="ns1" xmlns:b="ns2" a="1" b="2" c="3">',
			'<cdata>&lt;escaped name=&quot;&amp;value;&quot; /&gt;</cdata>',
			'<empty></empty>',
			'</tags>').
]

{ #category : #tests }
XMLWriterTest >> testCanonicalXMLDeclarationsAndPIs [
	| writer |

	(writer := XMLWriter new)
		isCanonical: true;
		xml;
		comment: 'start of pi'.
	writer pi
		target: 'pi';
		data: 'preserved'.
	writer comment: 'end of pi'.

	self assert: writer contents = '<!--start of pi--><?pi preserved?><!--end of pi-->'.
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
XMLWriterTest >> testEntityReference [
	| writer |

	(writer := XMLWriter new)
		tag: 'entities'
		with: [
			writer & 'one'.
			writer string: 'two'.
			writer & 'three'].

	self assert: writer contents = '<entities>&one;two&three;</entities>'.
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
XMLWriterTest >> testPrettyPrintingDTDs [
	| writer  |

	(writer := XMLWriter new)
		enablePrettyPrinting;
		xml.
	writer doctype
		root: 'pretty';
		with: [
			writer comment: 'element'.
			writer elementDeclaration
				name: 'pretty';
				contentModel: 'EMPTY'.
			writer comment: 'entity'.
			writer entityDeclaration
				isParameter: true;
				name: 'comment';
				replacement: '<!--attribute-->'.
			writer % 'comment'.
			writer attributeDeclaration
				element: 'pretty';
				attribute: 'name';
				type: 'CDATA';
				defaultPragma: '#REQUIRED'.
			writer comment: 'notation'.
			writer notationDeclaration
				name: 'external';
				systemID: 'external.txt'].

	self assert: writer contents = '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE pretty [
    <!--element-->
    <!ELEMENT pretty EMPTY>
    <!--entity-->
    <!ENTITY % comment "<!--attribute-->">
    %comment;
    <!ATTLIST pretty name CDATA #REQUIRED>
    <!--notation-->
    <!NOTATION external SYSTEM "external.txt">
]>
'.
]

{ #category : #tests }
XMLWriterTest >> testPrettyPrintingElements [
	| writer  |

	(writer := XMLWriter new)
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
XMLWriterTest >> testSelfClosingTags [
	| writer |

	(writer := XMLWriter new)
		tag: 'tags' with: [
			writer
				tag: 'self-closing' with: nil;
				outputsSelfClosingTags: false;
				tag: 'not-self-closing' with: nil;
				outputsSelfClosingTags: true;
				tag: 'self-closing' with: nil].

	self assert:
		writer printString =
			'<tags><self-closing /><not-self-closing></not-self-closing><self-closing /></tags>'.
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
	| block contents |

	block :=
		[:writer |
			writer tag
				name: 'emptyTag';
				attributeAt: 'a' put: 'value'].
	contents := '<emptyTag a="value" />'.
	self
		assert: (XMLWriter new writeWith: block) contents = contents;
		assert: (XMLWriter writeWith: block) = contents.
]

{ #category : #tests }
XMLWriterTest >> testStartingAndFinishing [
	| writer outer inner |

	writer := XMLWriter new.

	(outer := writer tag)
		name: 'outer';
		attributeAt: 'test' put: 'value';
		xmlns: 'default';
		startWriting.

	(inner := writer tag: 'inner')
		startWriting.
	writer string: 'test'.
	(writer tag: 'empty')
		startWriting;
		finishWriting.
	inner finishWriting.

	self assert:
		writer contents =
			'<outer xmlns="default" test="value"><inner>test<empty /></inner></outer>'.
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
		assert: (tag xmlnsDeclarations at: 'ns4') isEmpty.

	self assert:
		writer contents =
			'<test xmlns="default2" xmlns:ns1="first" xmlns:ns2="second" xmlns:ns3="third" />'.
]
