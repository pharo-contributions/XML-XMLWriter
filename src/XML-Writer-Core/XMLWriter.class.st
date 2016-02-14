"
XMLWriter generates well-formed XML documents using an API similar to Seaside's canvas and tag brushes.

Markup can be created with the messages under ""writing."" The ones that take no arguments return instances of XMLMarkupWriter subclasses that can be configured with messages like #name: or #attributeAt:put:. Sending them #write or #with: (if they can have embedded markup) causes the markup writer's configuration to be committed and its markup to be written.

For markup writers that can have embedded markup, the argument to #with: can be a string, a block, a collection (of strings and blocks), or nil. A block can optionally take an argument, the XMLWriter. Creating additional markup will cause any unwritten markup from a previous markup writer to be written, as will sending #write, #contents, #printOn:, #asString, or #close.

Here is an example (evaluate with cmd-p):
	| writer |
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
				tag: 'id' with: '101']

If the last message sent isn't a writing message like #with: or #tag:with:, you may need to send #write to force writing any unwritten markup:
	String streamContents: [:stream |
		(XMLWriter on: stream)
			tag: 'first';
			tag: 'second';
			write].

The second tag forces the first to be written, but the second wouldn't be written if #write wasn't sent.

The #writeWith: message evaluates a block and automatically sends #write after, like how #fileNamed:do: automatically sends #close after:
	String streamContents: [:stream |
		(XMLWriter  on: stream)
			writeWith: [:writer |
				writer
					tag: 'first'
					with: [writer tag: 'second'].
				writer tag: 'third']].
"
Class {
	#name : #XMLWriter,
	#superclass : #Object,
	#instVars : [
		'stream',
		'markupWriterStack',
		'formatter',
		'lineBreak',
		'contentEscapes',
		'contentStringEscapes',
		'isEscaping',
		'isCanonical',
		'outputsSelfClosingTags',
		'omitsRedundantXMLNSDeclarations'
	],
	#classVars : [
		'ContentEscapes',
		'ContentNonEntityEscapes',
		'ContentStringEscapes',
		'ContentStringNonEntityEscapes',
		'EntityValueEscapes',
		'SpaceCharacter'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #private }
XMLWriter class >> defaultLineBreak [
	^ String cr
]

{ #category : #'class initialization' }
XMLWriter class >> initialize [
	"self initialize"

	self
		initializeContentEscapes;
		initializeContentNonEntityEscapes;
		initializeContentStringEscapes;
		initializeContentStringNonEntityEscapes;
		initializeEntityValueEscapes;
		initializeSpaceCharacter
]

{ #category : #'class initialization' }
XMLWriter class >> initializeContentEscapes [
	(ContentEscapes := Array new: 256)
		at: $& asciiValue put: '&amp;';
		at: $< asciiValue put: '&lt;';
		at: $> asciiValue put: '&gt;'; "required to escape ]]> in PCDATA"
		at: Character cr asciiValue put: #LineBreak;
		at: Character lf asciiValue put: #LineBreak
]

{ #category : #'class initialization' }
XMLWriter class >> initializeContentNonEntityEscapes [
	(ContentNonEntityEscapes := ContentEscapes copy)
		at: $& asciiValue
		put: nil
]

{ #category : #'class initialization' }
XMLWriter class >> initializeContentStringEscapes [
	(ContentStringEscapes := Array new: 256)
		at: $& asciiValue put: '&amp;';
		at: $< asciiValue put: '&lt;';
		at: $" asciiValue put: '&quot;';
		at: Character cr asciiValue put: #LineBreak;
		at: Character lf asciiValue put: #LineBreak
]

{ #category : #'class initialization' }
XMLWriter class >> initializeContentStringNonEntityEscapes [
	(ContentStringNonEntityEscapes := ContentStringEscapes copy)
		at: $& asciiValue
		put: nil
]

{ #category : #'class initialization' }
XMLWriter class >> initializeEntityValueEscapes [
	(EntityValueEscapes := Array new: 256)
		at: $" asciiValue put: '&#34;';
		at: $% asciiValue put: '&#37;';
		at: Character cr asciiValue put: #LineBreak;
		at: Character lf asciiValue put: #LineBreak
]

{ #category : #'class initialization' }
XMLWriter class >> initializeSpaceCharacter [
	SpaceCharacter := Character space
]

{ #category : #'instance creation' }
XMLWriter class >> new [
	^ self on: (String new: 512) writeStream
]

{ #category : #'instance creation' }
XMLWriter class >> on: aStream [
	^ self basicNew initialize on: aStream
]

{ #category : #'instance creation' }
XMLWriter class >> on: aStream formatter: aFormatter [
	^ (self on: aStream) formatter: aFormatter
]

{ #category : #writing }
XMLWriter class >> writeWith: aBlock [
	^ self new
		writeWith: aBlock;
		contents
]

{ #category : #writing }
XMLWriter >> % aParameterEntityReference [
	self paramEntityRef: aParameterEntityReference
]

{ #category : #writing }
XMLWriter >> & anEntityReference [
	self entityRef: anEntityReference
]

{ #category : #accessing }
XMLWriter >> activeDoctypeWriter [
	self markupWriterStack reverseDo: [:each |
		each isDoctypeWriter
			ifTrue: [^ each]].
	^ nil.
]

{ #category : #accessing }
XMLWriter >> activeMarkupWriter [
	| stackSize |

	"for speed"
	^ (stackSize := markupWriterStack size) > 0
		ifTrue: [markupWriterStack at: stackSize]
		ifFalse: [nil]
]

{ #category : #private }
XMLWriter >> activeMarkupWriterDo: aBlock [
	"evaluate aBlock for the active (top) markup writer until it
	is nil or is the same (still active) writer after evaluating"
	| activeMarkupWriter previousActiveMarkupWriter |

	[(activeMarkupWriter := self activeMarkupWriter) isNil
		or: [activeMarkupWriter == previousActiveMarkupWriter]]
		whileFalse: [
			aBlock value: activeMarkupWriter.
			previousActiveMarkupWriter := activeMarkupWriter]
]

{ #category : #accessing }
XMLWriter >> activeTagWriter [
	self markupWriterStack reverseDo: [:each |
		each isTagWriter
			ifTrue: [^ each]].
	^ nil.
]

{ #category : #converting }
XMLWriter >> asString [
	"for GS compatibility"
	^ self printString
]

{ #category : #testing }
XMLWriter >> atBeginning [
	"overridden in the GS version to use Stream>>atBeginning because
	not all streams are 0-based on GS"

	^ stream position = 0
]

{ #category : #writing }
XMLWriter >> attributeDeclaration [
	^ self pushNewMarkupWriter: XMLAttributeDeclarationWriter
]

{ #category : #writing }
XMLWriter >> cdata [
	^ self pushNewMarkupWriter: XMLCDataWriter
]

{ #category : #writing }
XMLWriter >> cdata: aString [
	self cdata
		string: aString;
		write
]

{ #category : #closing }
XMLWriter >> close [
	self write.
	stream close.
]

{ #category : #writing }
XMLWriter >> comment [
	^ self pushNewMarkupWriter: XMLCommentWriter
]

{ #category : #writing }
XMLWriter >> comment: aString [
	self comment
		string: aString;
		write
]

{ #category : #accessing }
XMLWriter >> contents [
	self write.
	^ stream contents.
]

{ #category : #writing }
XMLWriter >> doctype [
	^ self pushNewMarkupWriter: XMLDoctypeDeclarationWriter
]

{ #category : #writing }
XMLWriter >> elementDeclaration [
	^ self pushNewMarkupWriter: XMLElementDeclarationWriter
]

{ #category : #writing }
XMLWriter >> enablePrettyPrinting [
	self formatter: (XMLPrettyPrintingWriterFormatter writer: self)
]

{ #category : #writing }
XMLWriter >> endTag [
	"Returns a new XMLUnsafeEndTagWriter for writing an end tag to close an element
	started by a #startTag* message.

	Use the #tag* messages instead if possible."

	^ self pushNewMarkupWriter: XMLUnsafeEndTagWriter
]

{ #category : #writing }
XMLWriter >> endTag: aName [
	"Returns a new XMLUnsafeEndTagWriter for writing an end tag with the specified
	name to close an element started by a #startTag* message.

	Use the #tag* messages instead if possible."

	^ self endTag name: aName
]

{ #category : #writing }
XMLWriter >> entityDeclaration [
	^ self pushNewMarkupWriter: XMLEntityDeclarationWriter
]

{ #category : #writing }
XMLWriter >> entityRef [
	^ self pushNewMarkupWriter: XMLEntityReferenceWriter
]

{ #category : #writing }
XMLWriter >> entityRef: aName [
	self entityRef
		name: aName;
		write
]

{ #category : #testing }
XMLWriter >> escapesContentEntityReferences [
	^ (contentEscapes at: $& asciiValue) notNil
		and: [(contentStringEscapes at: $& asciiValue) notNil]
]

{ #category : #accessing }
XMLWriter >> escapesContentEntityReferences: aBoolean [
	aBoolean
		ifTrue: [
			contentEscapes := ContentEscapes.
			contentStringEscapes := ContentStringEscapes]
		ifFalse: [
			contentEscapes := ContentNonEntityEscapes.
			contentStringEscapes := ContentStringNonEntityEscapes]
]

{ #category : #formatting }
XMLWriter >> formatAfterCData: aCDataWriter [
	formatter
		ifNotNil: [formatter formatAfterCData: aCDataWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterCharacterEscape: aCharacterEscape [
	formatter
		ifNotNil: [formatter formatAfterCharacterEscape: aCharacterEscape]
]

{ #category : #formatting }
XMLWriter >> formatAfterComment: aCommentWriter [
	formatter
		ifNotNil: [formatter formatAfterComment: aCommentWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterDeclaration: aDeclarationWriter [
	formatter
		ifNotNil: [formatter formatAfterDeclaration: aDeclarationWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterDoctypeDeclaration: aDoctypeDeclarationWriter [
	formatter
		ifNotNil: [formatter formatAfterDoctypeDeclaration: aDoctypeDeclarationWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterEndTag: aTagWriter [
	formatter
		ifNotNil: [formatter formatAfterEndTag: aTagWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterEntityReference: anEntityReferenceWriter [
	formatter
		ifNotNil: [formatter formatAfterEntityReference: anEntityReferenceWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterInternalSubset: aDoctypeDeclarationWriter [
	formatter
		ifNotNil: [formatter formatAfterInternalSubset: aDoctypeDeclarationWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterPI: aPIWriter [
	formatter
		ifNotNil: [formatter formatAfterPI: aPIWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterQuotedStringValue: aString [
	formatter
		ifNotNil: [formatter formatAfterQuotedStringValue: aString]
]

{ #category : #formatting }
XMLWriter >> formatAfterStartTag: aTagWriter [
	formatter
		ifNotNil: [formatter formatAfterStartTag: aTagWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterXMLDeclaration: anXMLDeclarationWriter [
	formatter
		ifNotNil: [formatter formatAfterXMLDeclaration: anXMLDeclarationWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeCData: aCDataWriter [
	formatter
		ifNotNil: [formatter formatBeforeCData: aCDataWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeCharacterEscape: aCharacterEscape [
	formatter
		ifNotNil: [formatter formatBeforeCharacterEscape: aCharacterEscape]
]

{ #category : #formatting }
XMLWriter >> formatBeforeComment: aCommentWriter [
	formatter
		ifNotNil: [formatter formatBeforeComment: aCommentWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeDeclaration: aDeclarationWriter [
	formatter
		ifNotNil: [formatter formatBeforeDeclaration: aDeclarationWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeDoctypeDeclaration: aDoctypeDeclarationWriter [
	formatter
		ifNotNil: [formatter formatBeforeDoctypeDeclaration: aDoctypeDeclarationWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeEndTag: aTagWriter [
	formatter
		ifNotNil: [formatter formatBeforeEndTag: aTagWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeEntityReference: anEntityReferenceWriter [
	formatter
		ifNotNil: [formatter formatBeforeEntityReference: anEntityReferenceWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeInternalSubset: aDoctypeDeclarationWriter [
	formatter
		ifNotNil: [formatter formatBeforeInternalSubset: aDoctypeDeclarationWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforePI: aPIWriter [
	formatter
		ifNotNil: [formatter formatBeforePI: aPIWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeQuotedStringValue: aString [
	formatter
		ifNotNil: [formatter formatBeforeQuotedStringValue: aString]
]

{ #category : #formatting }
XMLWriter >> formatBeforeStartTag: aTagWriter [
	formatter
		ifNotNil: [formatter formatBeforeStartTag: aTagWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeXMLDeclaration: anXMLDeclarationWriter [
	formatter
		ifNotNil: [formatter formatBeforeXMLDeclaration: anXMLDeclarationWriter]
]

{ #category : #accessing }
XMLWriter >> formatter [
	^ formatter
]

{ #category : #accessing }
XMLWriter >> formatter: aFormatter [
	(formatter := aFormatter) writer: self
]

{ #category : #testing }
XMLWriter >> isCanonical [
	^ isCanonical
]

{ #category : #accessing }
XMLWriter >> isCanonical: aBoolean [
	isCanonical := aBoolean
]

{ #category : #testing }
XMLWriter >> isEscaping [
	^ isEscaping
]

{ #category : #accessing }
XMLWriter >> isEscaping: aBoolean [
	isEscaping := aBoolean
]

{ #category : #accessing }
XMLWriter >> lineBreak [
	^ lineBreak
]

{ #category : #accessing }
XMLWriter >> lineBreak: aCharacterOrString [
	lineBreak := aCharacterOrString asString
]

{ #category : #private }
XMLWriter >> markupWriterStack [
	^ markupWriterStack
]

{ #category : #private }
XMLWriter >> newStringMarkup [
	self activeMarkupWriterDo: [:each | each newStringMarkupBeingWritten]
]

{ #category : #private }
XMLWriter >> nextPut: aCharacter [
	^ stream nextPut: aCharacter
]

{ #category : #private }
XMLWriter >> nextPutAll: aString [
	^ stream nextPutAll: aString
]

{ #category : #writing }
XMLWriter >> notationDeclaration [
	^ self pushNewMarkupWriter: XMLNotationDeclarationWriter
]

{ #category : #testing }
XMLWriter >> omitsRedundantXMLNSDeclarations [
	^ omitsRedundantXMLNSDeclarations
]

{ #category : #accessing }
XMLWriter >> omitsRedundantXMLNSDeclarations: aBoolean [
	omitsRedundantXMLNSDeclarations := aBoolean
]

{ #category : #initialization }
XMLWriter >> on: aStream [
	stream := aStream.
	markupWriterStack := OrderedCollection new.
	lineBreak := self class defaultLineBreak.
	contentEscapes := ContentEscapes.
	contentStringEscapes := ContentStringEscapes.
	isEscaping := true.
	isCanonical := false.
	outputsSelfClosingTags := true.
	omitsRedundantXMLNSDeclarations := true.
]

{ #category : #testing }
XMLWriter >> outputsSelfClosingTags [
	^ outputsSelfClosingTags
]

{ #category : #accessing }
XMLWriter >> outputsSelfClosingTags: aBoolean [
	outputsSelfClosingTags := aBoolean
]

{ #category : #writing }
XMLWriter >> paramEntityRef [
	^ (self pushNewMarkupWriter: XMLEntityReferenceWriter) isParameter: true
]

{ #category : #writing }
XMLWriter >> paramEntityRef: aName [
	self paramEntityRef
		name: aName;
		write
]

{ #category : #accessing }
XMLWriter >> parentMarkupWriter [
	^ self activeMarkupWriter
		ifNotNil: [:activeMarkupWriter | self parentMarkupWriterOf: activeMarkupWriter]
]

{ #category : #accessing }
XMLWriter >> parentMarkupWriterOf: aMarkupWriter [
	self markupWriterStack size to: 2 by: -1 do: [:i |
		(self markupWriterStack at: i) == aMarkupWriter
			ifTrue: [^ self markupWriterStack at: i - 1]].
	^ nil.
]

{ #category : #writing }
XMLWriter >> pcdata: aString [
	self string: aString
]

{ #category : #writing }
XMLWriter >> pi [
	^ self pushNewMarkupWriter: XMLPIWriter
]

{ #category : #private }
XMLWriter >> popActiveMarkupWriter [
	^ self markupWriterStack removeLast
]

{ #category : #printing }
XMLWriter >> printOn: aStream [
	aStream nextPutAll: self contents
]

{ #category : #private }
XMLWriter >> pushNewMarkupWriter: aMarkupWriterClass [
	| newMarkupWriter |

	(newMarkupWriter := aMarkupWriterClass new) writer: self.
	self activeMarkupWriterDo: [:each | each newMarkupWriterBeingPushed].

	^ self markupWriterStack addLast: newMarkupWriter.
]

{ #category : #writing }
XMLWriter >> raw: aString [
	"writes unescaped string content"

	aString size > 0
		ifTrue: [
			self
				newStringMarkup;
				nextPutAll: aString]
]

{ #category : #private }
XMLWriter >> space [
	"redefined for speed and portability"
	stream nextPut: SpaceCharacter
]

{ #category : #writing }
XMLWriter >> startTag [
	"Returns a new XMLUnsafeStartTagWriter for writing a start tag that does
	not support embedding or automatic end tag generation.

	Use the #tag* messages instead if possible."

	^ self pushNewMarkupWriter: XMLUnsafeStartTagWriter
]

{ #category : #writing }
XMLWriter >> startTag: aName [
	"Returns a new XMLUnsafeStartTagWriter for writing a start tag with the
	specified name that does not support embedding or automatic end tag generation.

	Use the #tag* messages instead if possible."

	^ self startTag name: aName
]

{ #category : #writing }
XMLWriter >> startTag: aName attributes: aDictionaryOrArray [
	"Returns a new XMLUnsafeStartTagWriter for writing a start tag with the
	specified name and attributes that does not support embedding or automatic
	end tag generation.
	
	Use the #tag* messages instead if possible."

	^ (self startTag: aName)
		attributes: aDictionaryOrArray
]

{ #category : #private }
XMLWriter >> stream [
	^ stream
]

{ #category : #private }
XMLWriter >> stream: aStream [
	self on: aStream
]

{ #category : #writing }
XMLWriter >> string: aString [
	"writes XML-escaped string content"

	aString size > 0
		ifTrue: [
			self
				newStringMarkup;
				writeEscapedContent: aString]
]

{ #category : #writing }
XMLWriter >> tag [
	"returns a new XMLTagWriter for writing an element that supports embedding
	markup using #with: and automatic end tag generation"

	^ self pushNewMarkupWriter: XMLTagWriter
]

{ #category : #writing }
XMLWriter >> tag: aName [
	"returns a new XMLTagWriter for writing an element with the specified name
	that supports embedding markup using #with: and automatic end tag generation"

	^ self tag name: aName
]

{ #category : #writing }
XMLWriter >> tag: aName attributes: aDictionaryOrArray [
	"returns a new XMLTagWriter for writing an element with the specified name and
	attributes that supports embedding markup using #with: and automatic end tag
	generation"

	^ (self tag: aName)
		attributes: aDictionaryOrArray
]

{ #category : #writing }
XMLWriter >> tag: aName attributes: aDictionaryOrArray with: aStringOrCollectionOrBlock [
	"writes an element with the specified name, attributes, and embedded markup"

	^ (self tag: aName)
		attributes: aDictionaryOrArray;
		with: aStringOrCollectionOrBlock
]

{ #category : #writing }
XMLWriter >> tag: aName with: aStringOrCollectionOrBlock [
	"writes an element with the specified name and embedded markup"

	^ (self tag: aName) with: aStringOrCollectionOrBlock
]

{ #category : #writing }
XMLWriter >> write [
	self activeMarkupWriterDo: [:each |
		each isWriting
			ifFalse: [each write]]
]

{ #category : #private }
XMLWriter >> write: aString escapedWith: anEscapeTable [
	self isEscaping
		ifTrue: [| tableSize |
			tableSize := anEscapeTable size.
			"to:do: for performance"
			1 to: aString size do: [:i | | nextChar asciiValue |
				((asciiValue := (nextChar := aString at: i) asciiValue) > 0
					and: [asciiValue <= tableSize
						and: [(anEscapeTable at: asciiValue) notNil]])
					ifTrue: [| replacement |
						(replacement := anEscapeTable at: asciiValue) == #LineBreak
							ifTrue: [stream nextPutAll: self lineBreak]
							ifFalse: [
								self formatBeforeCharacterEscape: replacement.
								stream nextPutAll: replacement.
								self formatAfterCharacterEscape: replacement]]
					ifFalse: [stream nextPut: nextChar]]]
		ifFalse: [stream nextPutAll: aString]
]

{ #category : #private }
XMLWriter >> writeAttributeName: aName value: aValue [ 
	self
		space;
		writeName: aName escapedContentValue: aValue
]

{ #category : #private }
XMLWriter >> writeAttributes: anAttributeCollection [
	anAttributeCollection
		ifNotNil: [
			self isCanonical
				ifTrue: [anAttributeCollection writeSortedAttributesOn: self]
				ifFalse: [anAttributeCollection writeAttributesOn: self]]
]

{ #category : #private }
XMLWriter >> writeEscapedContent: aString [
	self
		write: aString
		escapedWith: contentEscapes
]

{ #category : #private }
XMLWriter >> writeEscapedContentString: aString [
	self
		nextPut: $";
		formatBeforeQuotedStringValue: aString;
		write: aString escapedWith: contentStringEscapes;
		formatAfterQuotedStringValue: aString;
		nextPut: $"
]

{ #category : #private }
XMLWriter >> writeEscapedEntityValueString: aString [
	self
		nextPut: $";
		formatBeforeQuotedStringValue: aString;
		write: aString escapedWith: EntityValueEscapes;
		formatAfterQuotedStringValue: aString;
		nextPut: $"
]

{ #category : #private }
XMLWriter >> writeName: aString [
	stream nextPutAll: aString
]

{ #category : #private }
XMLWriter >> writeName: aName escapedContentValue: aValue [
	self
		writeName: aName;
		nextPut: $=;
		writeEscapedContentString: aValue
]

{ #category : #private }
XMLWriter >> writeName: aName unescapedValue: aValue [
	self
		writeName: aName;
		nextPut: $=;
		writeUnescapedString: aValue
]

{ #category : #private }
XMLWriter >> writeUnescapedString: aString [
	| quote |

	quote :=
		(aString includes: $")
			ifTrue: [$']
			ifFalse: [$"].
	self
		nextPut: quote;
		formatBeforeQuotedStringValue: aString.
	aString do: [:each |
		"delimiters are skipped because they can't be escaped here"
		each == quote
			ifFalse: [self nextPut: each]].
	self	
		formatAfterQuotedStringValue: aString;
		nextPut: quote.
]

{ #category : #private }
XMLWriter >> writeUnwrittenMarkupWritersEmbeddedIn: aMarkupWriter [
	self activeMarkupWriterDo: [:each |
		each == aMarkupWriter
			ifTrue: [^ self].
		each isWriting
			ifFalse: [each write]]
]

{ #category : #writing }
XMLWriter >> writeWith: aBlock [
	aBlock cull: self.
	self write.
]

{ #category : #private }
XMLWriter >> writeXMLNS: aPrefix uri: aURI [
	self
		space;
		writeName:
			(aPrefix isEmpty
				ifTrue: ['xmlns']
				ifFalse: ['xmlns:', aPrefix])
		escapedContentValue: aURI
]

{ #category : #private }
XMLWriter >> writeXMLNSDeclarations: aDictionary [
	| checkForDuplicates parentMarkupWriter |

	aDictionary
		ifNil: [^ self].
	checkForDuplicates := 
		self omitsRedundantXMLNSDeclarations
			and: [(parentMarkupWriter := self parentMarkupWriter) notNil
				and: [parentMarkupWriter isTagWriter]].
	self isCanonical
		ifTrue: [
			(aDictionary keys reject: [:prefix |
				(checkForDuplicates
					and: [parentMarkupWriter xmlnsAt: prefix]) = (aDictionary at: prefix)])
				sort;
				do: [:prefix |
					self
						writeXMLNS: prefix
						uri: (aDictionary at: prefix)]]
		ifFalse: [
			aDictionary keysDo: [:prefix | | uri |
				uri := aDictionary at: prefix.
				(checkForDuplicates
					and: [(parentMarkupWriter xmlnsAt: prefix) = uri])
					ifFalse: [
						self
							writeXMLNS: prefix
							uri: uri]]].
]

{ #category : #writing }
XMLWriter >> xml [
	^ self xmlDeclaration
]

{ #category : #writing }
XMLWriter >> xmlDeclaration [
	^ self pushNewMarkupWriter: XMLXMLDeclarationWriter
]
