"
This class allows you to generate well-formed XML documents using an API similar to Seaside's canvas and tag brush API.

Markup can be created by sending an instance any of the messages under ""writing markup."" The messages that take no arguments return an instance of an XMLMarkupWriter subclass. These objects can be configured with messages like #name: and #attributeAt:put:. Sending them #write or a specific writing message that accepts markup to embed within (the generic #with: message) causes the markup writer's configuration to be committed and its markup to be written to the output stream. For markup writers that can have embedded markup, the argument to the writing message can be a string, collection (of strings and blocks), a block, or nil. The block passed in can optionally take an argument, which will be the XMLWriter object that created the markup writer object. Within the block you can generate additional, child markup that will be contained by the parent. Creating additional non-embedded markup will cause any unwritten markup from a previous markup writer to be written, as will sending an XMLWriter or XMLMarkupWriter #contents, #printOn:, or the aforementioned #write.

Here is an example that you can highlight and evaluate with cmd-p to see the result:

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

Since the last message sent (#tag:with:) is an explicit serialization message, #write does not need to be sent. However, if you don't end with a serialization message, you must end with #write:

	| writer |
	writer := XMLWriter new.
	writer tag
		name: 'emptyTag';
		attributeAt: 'a' put: 'one';
		write.

Sending #write to the XMLWriter or markup writer object has the same effect. A simple way to avoid having to remember to send #write is to generate all markup within a top-level #writeWith: block, which will do it for you automatically:

	XMLWriter new
		writeWith: [:writer |
			writer tag
				name: 'emptyTag';
				attributeAt: 'a' put: 'value'].
"
Class {
	#name : #XMLWriter,
	#superclass : #Object,
	#instVars : [
		'stream',
		'markupWriterStack',
		'formatter',
		'lineBreak',
		'isEscaping',
		'isCanonical',
		'outputsSelfClosingTags',
		'omitsRedundantXmlnsDeclarations'
	],
	#classVars : [
		'ContentEscapes',
		'ContentStringEscapes',
		'EntityValueEscapes'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #'class initialization' }
XMLWriter class >> initialize [
	"self initialize"

	self
		initializeContentEscapes;
		initializeContentStringEscapes;
		initializeEntityValueEscapes
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
XMLWriter class >> initializeContentStringEscapes [
	(ContentStringEscapes := Array new: 256)
		at: $& asciiValue put: '&amp;';
		at: $< asciiValue put: '&lt;';
		at: $" asciiValue put: '&quot;';
		at: Character cr asciiValue put: #LineBreak;
		at: Character lf asciiValue put: #LineBreak
]

{ #category : #'class initialization' }
XMLWriter class >> initializeEntityValueEscapes [
	(EntityValueEscapes := Array new: 256)
		at: $" asciiValue put: '&#34;';
		at: $% asciiValue put: '&#37;';
		at: Character cr asciiValue put: #LineBreak;
		at: Character lf asciiValue put: #LineBreak
]

{ #category : #'instance creation' }
XMLWriter class >> new [
	^ self on: (String new: 512) writeStream
]

{ #category : #'instance creation' }
XMLWriter class >> on: aStream [
	^ self
		on: aStream
		formatter: nil
]

{ #category : #'instance creation' }
XMLWriter class >> on: aStream formatter: aFormatter [
	^ self basicNew initialize
		on: aStream
		formatter: aFormatter
]

{ #category : #'writing markup' }
XMLWriter class >> writeWith: aBlock [
	^ self new
		writeWith: aBlock;
		contents
]

{ #category : #'writing markup' }
XMLWriter >> % aParameterEntityReference [
	self paramEntityRef: aParameterEntityReference
]

{ #category : #'writing markup' }
XMLWriter >> & anEntityReference [
	self entityRef: anEntityReference
]

{ #category : #accessing }
XMLWriter >> activeMarkupWriter [
	"for speed"
	^ markupWriterStack size > 0
		ifTrue: [markupWriterStack at: markupWriterStack size]
		ifFalse: [nil]
]

{ #category : #private }
XMLWriter >> activeMarkupWriterDo: aBlock [
	"This evaluates aBlock for the active (top) markup writer until
	it is nil or is the same (still active) writer after evaluating aBlock"
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

{ #category : #printing }
XMLWriter >> asString [
	"for compatibility"
	^ self printString
]

{ #category : #testing }
XMLWriter >> atBeginning [
	^ stream position = 0
]

{ #category : #'writing markup' }
XMLWriter >> attributeDeclaration [
	^ self pushNewMarkupWriter: XMLAttributeDeclarationWriter
]

{ #category : #'writing markup' }
XMLWriter >> cdata [
	^ self pushNewMarkupWriter: XMLCDataWriter
]

{ #category : #'writing markup' }
XMLWriter >> cdata: aString [
	self cdata
		string: aString;
		write
]

{ #category : #'writing markup' }
XMLWriter >> close [
	self write.
	stream close.
]

{ #category : #'writing markup' }
XMLWriter >> comment [
	^ self pushNewMarkupWriter: XMLCommentWriter
]

{ #category : #'writing markup' }
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

{ #category : #private }
XMLWriter >> defaultLineBreak [
	^ String cr
]

{ #category : #'writing markup' }
XMLWriter >> doctype [
	^ self pushNewMarkupWriter: XMLDoctypeDeclarationWriter
]

{ #category : #'writing markup' }
XMLWriter >> elementDeclaration [
	^ self pushNewMarkupWriter: XMLElementDeclarationWriter
]

{ #category : #'writing markup' }
XMLWriter >> enablePrettyPrinting [
	self formatter: (XMLPrettyPrintingWriterFormatter writer: self)
]

{ #category : #'writing markup' }
XMLWriter >> entityDeclaration [
	^ self pushNewMarkupWriter: XMLEntityDeclarationWriter
]

{ #category : #'writing markup' }
XMLWriter >> entityRef: aName [
	(self pushNewMarkupWriter: XMLEntityReferenceWriter)
		name: aName;
		write
]

{ #category : #formatting }
XMLWriter >> formatAfterDoctypeDeclaration: aDoctypeDeclarationWriter [
	formatter
		ifNotNil: [formatter formatAfterDoctypeDeclaration: aDoctypeDeclarationWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterInternalSubset: aDoctypeDeclarationWriter [
	formatter
		ifNotNil: [formatter formatAfterInternalSubset: aDoctypeDeclarationWriter]
]

{ #category : #formatting }
XMLWriter >> formatAfterStartTag: aTagWriter [
	formatter
		ifNotNil: [formatter formatAfterStartTag: aTagWriter]
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
XMLWriter >> formatBeforePI: aPiWriter [
	formatter
		ifNotNil: [formatter formatBeforePI: aPiWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeStartTag: aTagWriter [
	formatter
		ifNotNil: [formatter formatBeforeStartTag: aTagWriter]
]

{ #category : #formatting }
XMLWriter >> formatBeforeXmlDeclaration: anXmlDeclarationWriter [
	formatter
		ifNotNil: [formatter formatBeforeXmlDeclaration: anXmlDeclarationWriter]
]

{ #category : #accessing }
XMLWriter >> formatter [
	^ formatter
]

{ #category : #accessing }
XMLWriter >> formatter: aFormatter [
	formatter := aFormatter
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

{ #category : #'writing markup' }
XMLWriter >> notationDeclaration [
	^ self pushNewMarkupWriter: XMLNotationDeclarationWriter
]

{ #category : #testing }
XMLWriter >> omitsRedundantXmlnsDeclarations [
	^ omitsRedundantXmlnsDeclarations
]

{ #category : #accessing }
XMLWriter >> omitsRedundantXmlnsDeclarations: aBoolean [
	omitsRedundantXmlnsDeclarations := aBoolean
]

{ #category : #initialization }
XMLWriter >> on: aStream [
	self
		on: aStream
		formatter: self formatter
]

{ #category : #initialization }
XMLWriter >> on: aStream formatter: aFormatter [
	stream := aStream.
	markupWriterStack := OrderedCollection new.
	formatter := aFormatter.
	lineBreak := self defaultLineBreak.
	isEscaping := true.
	isCanonical := false.
	outputsSelfClosingTags := true.
	omitsRedundantXmlnsDeclarations := true.
]

{ #category : #testing }
XMLWriter >> outputsSelfClosingTags [
	^ outputsSelfClosingTags
]

{ #category : #accessing }
XMLWriter >> outputsSelfClosingTags: aBoolean [
	outputsSelfClosingTags := aBoolean
]

{ #category : #'writing markup' }
XMLWriter >> paramEntityRef: aName [
	(self pushNewMarkupWriter: XMLEntityReferenceWriter)
		isParameter: true;
		name: aName;
		write
]

{ #category : #accessing }
XMLWriter >> parentMarkupWriterOf: aMarkupWriter [
	self markupWriterStack size to: 2 by: -1 do: [:i |
		(self markupWriterStack at: i) == aMarkupWriter
			ifTrue: [^ self markupWriterStack at: i - 1]].
	^ nil.
]

{ #category : #'writing markup' }
XMLWriter >> pcdata: aString [
	self string: aString
]

{ #category : #'writing markup' }
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

	newMarkupWriter := aMarkupWriterClass writer: self.
	self activeMarkupWriterDo: [:each | each newMarkupWriterBeingPushed].

	^ self markupWriterStack addLast: newMarkupWriter.
]

{ #category : #'writing markup' }
XMLWriter >> raw: aString [
	self
		newStringMarkup;
		nextPutAll: aString
]

{ #category : #private }
XMLWriter >> space [
	stream space
]

{ #category : #private }
XMLWriter >> stream [
	^ stream
]

{ #category : #private }
XMLWriter >> stream: aStream [
	stream := aStream
]

{ #category : #'writing markup' }
XMLWriter >> string: aString [
	self
		newStringMarkup;
		writeEscapedContent: aString
]

{ #category : #'writing markup' }
XMLWriter >> tag [
	^ self pushNewMarkupWriter: XMLTagWriter
]

{ #category : #'writing markup' }
XMLWriter >> tag: aName [
	^ self tag name: aName
]

{ #category : #'writing markup' }
XMLWriter >> tag: aName attributes: aDictionaryOrArray [
	^ (self tag: aName)
		attributes: aDictionaryOrArray
]

{ #category : #'writing markup' }
XMLWriter >> tag: aName attributes: aDictionaryOrArray with: aStringOrCollectionOrBlock [
	^ (self tag: aName)
		attributes: aDictionaryOrArray;
		with: aStringOrCollectionOrBlock
]

{ #category : #'writing markup' }
XMLWriter >> tag: aName with: aStringOrCollectionOrBlock [
	^ (self tag: aName) with: aStringOrCollectionOrBlock
]

{ #category : #'writing markup' }
XMLWriter >> write [
	self activeMarkupWriterDo: [:each |
		each isWriting
			ifTrue: [each finishWriting]
			ifFalse: [each write]]
]

{ #category : #private }
XMLWriter >> write: aString escapedWith: anEscapeTable [
	self isEscaping
		ifTrue: [| tableSize |
			tableSize := anEscapeTable size.
			1 to: aString size do: [:i | | nextChar asciiValue |
				((asciiValue := (nextChar := aString at: i) asciiValue) > 0
					and: [asciiValue <= tableSize
						and: [(anEscapeTable at: asciiValue) notNil]])
					ifTrue: [| replacement |
						stream nextPutAll:
							((replacement := anEscapeTable at: asciiValue) == #LineBreak
								ifTrue: [self lineBreak]
								ifFalse: [replacement])]
					ifFalse: [stream nextPut: nextChar]]]
		ifFalse: [stream nextPutAll: aString]
]

{ #category : #private }
XMLWriter >> writeEscapedContent: aString [
	self write: aString escapedWith: ContentEscapes
]

{ #category : #private }
XMLWriter >> writeEscapedContentString: aString [
	self
		nextPut: $";
		write: aString escapedWith: ContentStringEscapes;
		nextPut: $"
]

{ #category : #private }
XMLWriter >> writeEscapedEntityValueString: aString [
	self
		nextPut: $";
		write: aString escapedWith: EntityValueEscapes;
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
	self nextPut: quote.
	aString do: [:each |
		"strip delimiter because it can't be escaped with an entity in this type of string"
		each == quote
			ifFalse: [self nextPut: each]].
	self nextPut: quote.
]

{ #category : #private }
XMLWriter >> writeUnwrittenMarkupWritersEmbeddedIn: aMarkupWriter [
	self activeMarkupWriterDo: [:each |
		each == aMarkupWriter
			ifTrue: [^ self].
		each isWriting
			ifTrue: [each finishWriting]
			ifFalse: [each write]]
]

{ #category : #'writing markup' }
XMLWriter >> writeWith: aBlock [
	aBlock cull: self.
	self write.
]

{ #category : #'writing markup' }
XMLWriter >> xml [
	^ self pushNewMarkupWriter: XMLXmlDeclarationWriter
]
