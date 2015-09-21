"
A simple test case class. 
Please add more tests to it!
"
Class {
	#name : #XMLWriterTest,
	#superclass : #TestCase,
	#category : #'XML-Writer-Tests'
}

{ #category : #private }
XMLWriterTest >> prettyPrintedLines: anArrayOfLineArrays [
	| lineNumber |
	"takes an array of arrays where the first element of each is the indent level
	and the rest are the lines with that indent level"

	lineNumber := 1.
	^ String streamContents: [:stream |
		anArrayOfLineArrays do: [:each | | indentLevel |
			indentLevel := XMLPrettyPrintingWriterFormatter defaultIndentLevel + each first.
			2 to: each size do: [:lineIndex |
				lineNumber > 1
					ifTrue: [
						stream nextPutAll: XMLWriter defaultLineBreak.
						indentLevel timesRepeat: [
							stream nextPutAll:
								XMLPrettyPrintingWriterFormatter defaultIndentString]].
				stream nextPutAll: (each at: lineIndex).
				lineNumber := lineNumber + 1]]]
]

{ #category : #tests }
XMLWriterTest >> testActiveDoctypeWriter [
	| writer doctypeWriter |

	writer := XMLWriter new.
	self assert: writer activeDoctypeWriter isNil.

	doctypeWriter := writer doctype.
	self assert: writer activeDoctypeWriter == doctypeWriter.

	doctypeWriter with: [
		writer comment: 'test'.
		self assert: writer activeDoctypeWriter == doctypeWriter].

	self assert: writer activeDoctypeWriter isNil.
]

{ #category : #tests }
XMLWriterTest >> testActiveTagWriter [
	| writer tagWriter |

	writer := XMLWriter new.
	self assert: writer activeTagWriter isNil.
	writer xml.
	self assert: writer activeTagWriter isNil.

	tagWriter := writer tag: 'one'.
	self assert: writer activeTagWriter == tagWriter.

	tagWriter with: [| newTagWriter |
		self assert: writer activeTagWriter == tagWriter.

		newTagWriter := writer tag: 'three'.
		self assert: writer activeTagWriter == newTagWriter.
	
		newTagWriter write.
		self assert: writer activeTagWriter == tagWriter].

	self assert: writer activeTagWriter isNil.
]

{ #category : #tests }
XMLWriterTest >> testAsString [
	self assert:
		(XMLWriter new
			tag: 'one';
			tag: 'two';
			asString) = '<one /><two />'.
	self assert:
		(XMLWriter new
			tag: 'one';
			tag: 'two') asString = '<one /><two />'.
]

{ #category : #tests }
XMLWriterTest >> testAtBeginning [
	"on GS writeStream gives an ANSI 0-based position stream,
	on: doesn't, so both are tested"
	(Array
		with: String new writeStream
		with: (WriteStream on: String new))
		do: [:stream | | writer |
			writer := XMLWriter on: stream.
			self assert: writer atBeginning.

			stream nextPut: $<.
			self deny: writer atBeginning]
]

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
			writer
				cdata: '<escaped name="&value;" />';
				cdata:
					(XMLWriter writeWith: [:w |
						w
							tag: 'escaped'
							with: [w & 'value']])].

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
XMLWriterTest >> testCanonicalOmitsRedundantXMLNSDeclarations [
	| withBlock |

	withBlock := [:writer |
		(writer tag: 'one')
			xmlns: 'defaultNS';
			xmlnsAt: 'prefix' put: 'prefixNS';
			with: [
				(writer tag: 'two')
					xmlns: 'defaultNS';
					xmlnsAt: 'prefix' put: 'prefixNS';
					with: [
						(writer tag: 'three')
							xmlns: 'newDefaultNS';
							xmlnsAt: 'prefix' put: 'newPrefixNS']]].
	self assert:
		(XMLWriter new
			isCanonical: true;
			writeWith: withBlock;
			contents) =
			('<one xmlns="defaultNS" xmlns:prefix="prefixNS"><two>',
			'<three xmlns="newDefaultNS" xmlns:prefix="newPrefixNS">',
			'</three></two></one>').
	self assert:
		(XMLWriter new
			omitsRedundantXMLNSDeclarations: false;
			isCanonical: true;
			writeWith: withBlock;
			contents) =
			('<one xmlns="defaultNS" xmlns:prefix="prefixNS">',
			'<two xmlns="defaultNS" xmlns:prefix="prefixNS">',
			'<three xmlns="newDefaultNS" xmlns:prefix="newPrefixNS">',
			'</three></two></one>').
	self assert:
		(XMLWriter new
			isCanonical: true;
			writeWith: [:writer | (writer tag: 'empty') xmlns: ''];
			contents) =
			'<empty xmlns=""></empty>'.
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
			'<cdata>&lt;escaped name="&amp;value;" /&gt;</cdata>',
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
XMLWriterTest >> testClose [
	self assert:
		(String streamContents: [:stream |
			(XMLWriter on: stream)
				tag: 'one';
				tag: 'two';
				close]) = '<one /><two />'.
	self assert:
		(String streamContents: [:stream |
			((XMLWriter on: stream)
				tag: 'one';
				tag: 'two') close]) = '<one /><two />'.
]

{ #category : #tests }
XMLWriterTest >> testContentEscaping [
	| writer |

	(writer := XMLWriter new)
		tag
			name: 'test';
			attributeAt: 'escaped' put: '& " < >';
			xmlns: '& " < >';
			with: '& " < >'.
	self assert:
		writer contents =
			'<test xmlns="&amp; &quot; &lt; >" escaped="&amp; &quot; &lt; >">&amp; " &lt; &gt;</test>'.

	((writer := XMLWriter new)
		isEscaping: false;
		tag)
			name: 'test';
			xmlns: '& " < >';
			attributeAt: 'unescaped' put: '& " < >';
			with: '& " < >'.
	self assert: writer contents = '<test xmlns="& " < >" unescaped="& " < >">& " < ></test>'.
]

{ #category : #tests }
XMLWriterTest >> testContents [
	self assert:
		(XMLWriter new
			tag: 'one';
			tag: 'two';
			contents) = '<one /><two />'.
	self assert:
		(XMLWriter new
			tag: 'one';
			tag: 'two') contents = '<one /><two />'.
]

{ #category : #tests }
XMLWriterTest >> testEmbedInMarkupWriter [
	(Array
		with: 'one<two/>three'
		with: #('one' nil '<two/>' 'three')
		with: #($o $n $e $< $t $w $o $/ $> nil $t $h $r $e $e)
		with:
			(Array
				with: [:w | w string: 'one']
				with: [:w | w string: '<two/>']
				with: [:w | w string: 'three']
				with: nil))
		do: [:each |
			self assert:
				(XMLWriter writeWith: [:writer |
					writer
						tag: 'test'
						with: each]) = '<test>one&lt;two/&gt;three</test>'].

	self assert:
		(XMLWriter writeWith: [:writer |
			writer
				tag: 'test'
				with: $<]) = '<test>&lt;</test>'.
	self assert:
		(XMLWriter writeWith: [:writer |
			writer
				tag: 'test'
				with: nil]) = '<test />'.
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
XMLWriterTest >> testEscapesContentEntityReferences [
	self assert:
		(XMLWriter writeWith: [:writer |
			(writer
				escapesContentEntityReferences: false;
				tag: 'one')
				attributeAt: 'two' put: '<"&three;">';
				with: '<"&four;">']) =
			'<one two="&lt;&quot;&three;&quot;>">&lt;"&four;"&gt;</one>'.

	self assert:
		(XMLWriter writeWith: [:writer |
			(writer
				escapesContentEntityReferences: true;
				tag: 'one')
				attributeAt: 'two' put: '<"&three;">';
				with: '<"&four;">']) =
			'<one two="&lt;&quot;&amp;three;&quot;>">&lt;"&amp;four;"&gt;</one>'.

	self assert: XMLWriter new escapesContentEntityReferences.
	self deny:
		(XMLWriter new
			escapesContentEntityReferences: false;
			escapesContentEntityReferences).
]

{ #category : #tests }
XMLWriterTest >> testFormatter [
	| writer formatter |

	writer := XMLWriter new.
	self assert: writer formatter isNil.

	formatter := XMLPrettyPrintingWriterFormatter new.
	writer formatter: formatter.
	self
		assert: writer formatter == formatter;
		assert: formatter writer == writer.
]

{ #category : #tests }
XMLWriterTest >> testFormattingContent [
	| formatter writer tagWriter commentWriter piWriter entityRefWriter |

	formatter := XMLWriterRecordingFormatterProxy new.
	(writer := XMLWriter new) formatter: formatter.
	(tagWriter := writer tag: 'empty') write.
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeStartTag: formatAfterEndTag:)
			with: tagWriter).
	
	(tagWriter := writer tag: 'not-empty')
		xmlns: 'defaultNS';
		attributeAt: 'name' put: 'value';
		with: [
			(commentWriter := writer comment) string: 'test'.
			(piWriter := writer pi)
				target: 'test';
				data: 'test'.
			(entityRefWriter := writer entityRef) name: 'test'].
	self assert:
		(formatter
			receivedNext: #formatBeforeStartTag:
			with: tagWriter).
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeQuotedStringValue: formatAfterQuotedStringValue:)
			with: 'defaultNS').
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeQuotedStringValue: formatAfterQuotedStringValue:)
			with: 'value').
	self assert:
		(formatter
			receivedNext: #formatAfterStartTag:
			with: tagWriter).
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeComment: formatAfterComment:)
			with: commentWriter).
	self assert:
		(formatter
			receivedNextAll: #(formatBeforePI: formatAfterPI:)
			with: piWriter).
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeEntityReference: formatAfterEntityReference:)
			with: entityRefWriter).
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeEndTag: formatAfterEndTag:)
			with: tagWriter).

	writer outputsSelfClosingTags: false.
	(tagWriter := writer tag: 'empty') write.
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeStartTag: formatAfterStartTag: formatBeforeEndTag: formatAfterEndTag:)
			with: tagWriter).
]

{ #category : #tests }
XMLWriterTest >> testFormattingProlog [
	| formatter writer xmlDeclarationWriter doctypeWriter paramEntityDeclarationWriter paramEntityRefWriter |

	formatter := XMLWriterRecordingFormatterProxy new.
	(writer := XMLWriter new) formatter: formatter.
	(xmlDeclarationWriter := writer xml) write.
	self assert:
		(formatter
			receivedNext: #formatBeforeXMLDeclaration:
			with: xmlDeclarationWriter).
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeQuotedStringValue: formatAfterQuotedStringValue:)
			with: '1.0').
	self assert:
		(formatter
			receivedNext: #formatAfterXMLDeclaration:
			with: xmlDeclarationWriter).

	(doctypeWriter := writer doctype)
		root: 'test';
		with: [
			(paramEntityDeclarationWriter := writer entityDeclaration)
				isParameter: true;
				name: 'test';
				replacement: 'replacement'.
			(paramEntityRefWriter := writer paramEntityRef) name: 'test'].
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeDoctypeDeclaration: formatBeforeInternalSubset:)
			with: doctypeWriter).
	self assert:
		(formatter
			receivedNext: #formatBeforeDeclaration:
			with: paramEntityDeclarationWriter).
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeQuotedStringValue: formatAfterQuotedStringValue:)
			with: 'replacement').
	self assert:
		(formatter
			receivedNext: #formatAfterDeclaration:
			with: paramEntityDeclarationWriter).
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeEntityReference: formatAfterEntityReference:)
			with: paramEntityRefWriter).
	self assert:
		(formatter
			receivedNextAll: #(formatAfterInternalSubset: formatAfterDoctypeDeclaration:)
			with: doctypeWriter).
]

{ #category : #tests }
XMLWriterTest >> testFormattingUnsafeTagWriters [
	| formatter writer tagWriter |

	formatter := XMLWriterRecordingFormatterProxy new.
	(writer := XMLWriter new) formatter: formatter.
	(tagWriter := writer startTag: 'test')
		xmlns: 'defaultNS';
		attributeAt: 'name' put: 'value';
		write.
	self assert:
		(formatter
			receivedNext: #formatBeforeStartTag:
			with: tagWriter).
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeQuotedStringValue: formatAfterQuotedStringValue:)
			with: 'defaultNS').
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeQuotedStringValue: formatAfterQuotedStringValue:)
			with: 'value').
	self assert:
		(formatter
			receivedNext: #formatAfterStartTag:
			with: tagWriter).
	(tagWriter := writer endTag: 'empty') write.
	self assert:
		(formatter
			receivedNextAll: #(formatBeforeEndTag: formatAfterEndTag:)
			with: tagWriter).
]

{ #category : #tests }
XMLWriterTest >> testLineBreak [
	| writer  |

	(writer := XMLWriter new)
		enablePrettyPrinting;
		lineBreak: $N.
	writer
		xml;
		tag: 'test'.
	self assert: writer contents = '<?xml version="1.0"?>N<test />'
]

{ #category : #tests }
XMLWriterTest >> testOmitsRedundantXMLNSDeclarations [
	| withBlock |

	withBlock := [:writer |
		(writer tag: 'one')
			xmlns: 'defaultNS';
			xmlnsAt: 'prefix' put: 'prefixNS';
			with: [
				(writer tag: 'two')
					xmlns: 'defaultNS';
					xmlnsAt: 'prefix' put: 'prefixNS';
					with: [
						(writer tag: 'three')
							xmlns: 'newDefaultNS';
							xmlnsAt: 'prefix' put: 'newPrefixNS']]].
	self assert:
		(XMLWriter writeWith: withBlock) =
			('<one xmlns="defaultNS" xmlns:prefix="prefixNS"><two>',
			'<three xmlns="newDefaultNS" xmlns:prefix="newPrefixNS" />',
			'</two></one>').
	self assert:
		(XMLWriter new
			omitsRedundantXMLNSDeclarations: false;
			writeWith: withBlock;
			contents) =
			('<one xmlns="defaultNS" xmlns:prefix="prefixNS">',
			'<two xmlns="defaultNS" xmlns:prefix="prefixNS">',
			'<three xmlns="newDefaultNS" xmlns:prefix="newPrefixNS" />',
			'</two></one>').
	self assert:
		(XMLWriter writeWith: [:writer | (writer tag: 'empty') xmlns: '']) =
			'<empty xmlns="" />'.
]

{ #category : #tests }
XMLWriterTest >> testOnFormatter [
	| stream formatter writer |

	stream := String new writeStream.
	formatter := XMLWriterRecordingFormatterProxy new.
	writer := XMLWriter on: stream formatter: formatter.
	self
		assert: writer stream == stream;
		assert: writer formatter == formatter.
]

{ #category : #tests }
XMLWriterTest >> testOutputsSelfClosingTags [
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
XMLWriterTest >> testParentMarkupWriter [
	| writer xmlDeclarationWriter tagWriter |

	writer := XMLWriter new.
	self assert: writer parentMarkupWriter isNil.
	xmlDeclarationWriter := writer xml.
	self
		assert: writer parentMarkupWriter isNil;
		assert: xmlDeclarationWriter parentMarkupWriter isNil;
		assert: (writer parentMarkupWriterOf: xmlDeclarationWriter) isNil.

	tagWriter := writer tag: 'one'.
	self
		assert: writer parentMarkupWriter isNil;
		assert: tagWriter parentMarkupWriter isNil;
		assert: (writer parentMarkupWriterOf: tagWriter) isNil.

	tagWriter with: [| newTagWriter |
		newTagWriter := writer tag: 'two'.
		self
			assert: writer parentMarkupWriter == tagWriter;
			assert: newTagWriter parentMarkupWriter == tagWriter;
			assert: (writer parentMarkupWriterOf: newTagWriter) == tagWriter].
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
			writer comment: 'attribute'.
			writer attributeDeclaration
				element: 'pretty';
				attribute: 'name';
				type: 'CDATA';
				defaultPragma: '#REQUIRED'.
			writer comment: 'notation'.
			writer notationDeclaration
				name: 'external';
				systemID: 'external.txt'].

	self assert:
		writer contents =
			(self prettyPrintedLines: #(
				#(0 '<?xml version="1.0"?>'
					'<!DOCTYPE pretty [')
				#(1 '<!--element-->'
					'<!ELEMENT pretty EMPTY>'
					'<!--entity-->'
					'<!ENTITY % comment "<!--attribute-->">'
					'%comment;'
					'<!--attribute-->'
					'<!ATTLIST pretty name CDATA #REQUIRED>'
					'<!--notation-->'
					'<!NOTATION external SYSTEM "external.txt">')
				#(0 ']>'
					''))).
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
				tag: 'username' with: [
					writer
						comment: 'id';
						string: 'jsmith'];
				tag: 'real-name' with: [
					writer tag: 'last-name' with: 'Smith'.
					writer string: ', '.
					writer pi
						target: 'type';
						data: 'string'.
					writer
						comment: 'first name';
						string: 'John'];
				tag: 'age' with: [
					writer pi
						target: 'type';
						data: 'integer'.
					writer comment: 'not supplied'];
				tag: 'id' with: [
					writer
						string: '101';
						comment: ''];
				tag: 'contact' with: [
					writer
						tag: 'email';
						string: 'alternate']].

	self assert:
		writer contents =
			(self prettyPrintedLines: #(
				#(0 '<?xml version="1.0"?>'
					'<!--an example-->'
					'<example:user xmlns:example="urn://example">')
				#(1 '<username>')
				#(2 '<!--id-->jsmith</username>')
				#(1 '<real-name>')
				#(2 '<last-name>Smith</last-name>, <?type string?><!--first name-->John</real-name>')
				#(1 '<age>')
				#(2 '<?type integer?>'
					'<!--not supplied-->')
				#(1 '</age>'
					'<id>101<!----></id>'
					'<contact>')
				#(2 '<email />alternate</contact>')
				#(0 '</example:user>'))).
]

{ #category : #tests }
XMLWriterTest >> testRaw [
	self assert:
		(XMLWriter writeWith: [:writer |
			writer
				tag: 'test'
				with: [writer raw: '<raw name="&value;"/>']]) =
				'<test><raw name="&value;"/></test>'
]

{ #category : #tests }
XMLWriterTest >> testRedundantWrites [
	self assert:
		(XMLWriter writeWith: [:writer |
			writer
				tag: 'report'
				with: [
					writer
						tag: 'name'
						with: 'TestName - Report'.
					writer write.
					writer writeWith: [:writer2 |
						writer2
							tag: 'finality'
							with: 'succeed'.
						writer2 write].
					writer write].
				writer write]) =
			('<report>',
			'<name>TestName - Report</name>',
			'<finality>succeed</finality>',
			'</report>')
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
	outer finishWriting.

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
XMLWriterTest >> testUnsafeTagWriters [
	self assert:
		(XMLWriter writeWith: [:writer |
			writer
				startTag: 'one';
				startTag: 'two' attributes: (Array with: 'name' -> 'value');
				string: 'test';
				endTag: 'two';
				endTag: 'one']) = '<one><two name="value">test</two></one>'
]

{ #category : #tests }
XMLWriterTest >> testXMLDeclarations [
	| writer  |

	(writer := XMLWriter new)
		xml.
	writer
		xml
			version: '1.10';
			encoding: 'UTF-16';
			standalone: false.
	writer
		xml
			version: '1.0';
			standalone: true.
	writer
		xml
			version: 1.10;
			encoding: 'UTF-16LE';
			standalone: 'yes'.
	writer
		xml
			version: 1.0;
			standalone: 'no'.
	writer
		xml
			version: '';
			encoding: '';
			standalone: ''.
		
	self assert:
		writer printString =
			('<?xml version="1.0"?>',
			'<?xml version="1.1" encoding="UTF-16"?>',
			'<?xml version="1.0" standalone="yes"?>',
			'<?xml version="1.1" encoding="UTF-16LE" standalone="yes"?>',
			'<?xml version="1.0"?>',
			'<?xml version="1.0"?>').
]

{ #category : #tests }
XMLWriterTest >> testXMLNSDeclarations [
	| writer tag |

	writer := XMLWriter new.
	tag := writer  tag: 'test'.
	self
		deny: tag hasXMLNSDeclarations;
		deny: (tag includesXMLNS: '');
		deny: (tag includesXMLNS: 'ns1').

	tag xmlnsDeclarations: (Array with: '' -> 'default1' with: 'ns1' -> 'first').
	self
		assert: tag hasXMLNSDeclarations;
		assert: (tag includesXMLNS: '');
		assert: (tag includesXMLNS: 'ns1');
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
