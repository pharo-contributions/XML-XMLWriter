"
This class generates XML tags for elements. You can specifiy the attributes of the start tag using the #attribute* messages, and you can add xmlns: namespace declarations using the #xmlns* messages. If you do not send #with:, or if you do but the argument is nil or a block that generates no markup, then only a single, empty tag in the form of ""<empty />"" will be generated, unless the writer object that created the tag writer object is configured to generate canonical XML, in which case an empty start/end tag pair like ""<empty></empty>"" will be generated.

You can supply child markup content using #with:. Namespace declarations will be ignored if a parent element has equivalent declarations (and they were thus already generated).
"
Class {
	#name : #XMLTagWriter,
	#superclass : #XMLEmbeddedMarkupWriter,
	#instVars : [
		'name',
		'attributes',
		'xmlnsDeclarations'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLTagWriter >> attributeAt: aName [
	^ self attributeAt: aName ifAbsent: ['']
]

{ #category : #accessing }
XMLTagWriter >> attributeAt: aName ifAbsent: aBlock [
	^ self attributes at: aName ifAbsent: aBlock
]

{ #category : #accessing }
XMLTagWriter >> attributeAt: aName ifAbsentPut: aBlock [
	^ self attributes at: aName ifAbsentPut: aBlock
]

{ #category : #accessing }
XMLTagWriter >> attributeAt: aName put: aValue [
	^ self attributes at: aName put: aValue
]

{ #category : #accessing }
XMLTagWriter >> attributes [
	^ attributes ifNil: [attributes := OrderPreservingDictionary defaultValue: '']
]

{ #category : #accessing }
XMLTagWriter >> attributes: aDictionaryOrArray [
	(attributes := OrderPreservingDictionary newFrom: aDictionaryOrArray) defaultValue: ''
]

{ #category : #testing }
XMLTagWriter >> escapesEmbeddedStrings [
	^ true
]

{ #category : #testing }
XMLTagWriter >> hasAttributes [
	^ self attributes notEmpty
]

{ #category : #testing }
XMLTagWriter >> includesAttribute: anAttribute [
	^ self attributes includesKey: anAttribute
]

{ #category : #testing }
XMLTagWriter >> isTagWriter [
	^ true
]

{ #category : #accessing }
XMLTagWriter >> name [
	^ name ifNil: ['']
]

{ #category : #accessing }
XMLTagWriter >> name: aName [
	name := aName
]

{ #category : #initialization }
XMLTagWriter >> setName: aName attributes: anAttributeDictionary xmlnsDeclarations: anXmlnsDictionary [
	name := aName.
	attributes := anAttributeDictionary.
	xmlnsDeclarations := anXmlnsDictionary.
]

{ #category : #private }
XMLTagWriter >> writeAttributes [
	attributes ifNotNil: [
		self
			writeKeysAndValuesFrom: attributes
			with: [:attributeName :attributeValue |
				self writer
					writeName: attributeName
					escapedContentValue: attributeValue]]
]

{ #category : #private }
XMLTagWriter >> writeEmbeddedMarkupPrologue [
	self writer
		nextPut: $>;
		indent
]

{ #category : #private }
XMLTagWriter >> writeEndTag [
	self writer
		nextPut: $<;
		nextPut: $/;
		writeName: self name;
		nextPut: $>
]

{ #category : #private }
XMLTagWriter >> writeEpilogue [
	self hasEmbeddedMarkup
		ifTrue: [
			self writer outdent.
			self hasEmbeddedMarkupWriters
				ifTrue: [self writer cr].
			self writeEndTag]
		ifFalse: [
			(self writer isCanonical
				or: [self writer outputsSelfClosingTags not])
				ifTrue: [
					self writer nextPut: $>.
					self writeEndTag]
				ifFalse: [
					self writer
						space;
						nextPut: $/;
						nextPut: $>]].
]

{ #category : #private }
XMLTagWriter >> writeKeysAndValuesFrom: aDictionary with: aTwoArgumentBlock [
	self writer isCanonical
		ifTrue: [
			aDictionary keys asSortedCollection do: [:each |
				aTwoArgumentBlock value: each value: (aDictionary at: each)]]
		ifFalse: [aDictionary keysAndValuesDo: aTwoArgumentBlock]
]

{ #category : #private }
XMLTagWriter >> writePrologue [
	self writer
		cr;
		nextPut: $<;
		writeName: self name.
	self
		writeXmlnsDeclarations;
		writeAttributes.
]

{ #category : #private }
XMLTagWriter >> writeXmlnsDeclarations [
	xmlnsDeclarations ifNil: [^ self].

	self
		writeKeysAndValuesFrom: xmlnsDeclarations
		with: [:prefix :uri |
			self writer
				writeName:
					(prefix
						ifEmpty: ['xmlns']
						ifNotEmpty: ['xmlns:', prefix])
				escapedContentValue: uri].
]

{ #category : #accessing }
XMLTagWriter >> xmlns [
	"default namespace"
	^ self xmlnsDeclarations at: ''
]

{ #category : #accessing }
XMLTagWriter >> xmlns: aUri [
	"set default namespace"
	self xmlnsDeclarations at: '' put: aUri
]

{ #category : #accessing }
XMLTagWriter >> xmlnsAt: aPrefix [
	^ self xmlnsDeclarations at: aPrefix ifAbsent: ['']
]

{ #category : #accessing }
XMLTagWriter >> xmlnsAt: aPrefix ifAbsent: aBlock [
	^ self xmlnsDeclarations at: aPrefix ifAbsent: aBlock
]

{ #category : #accessing }
XMLTagWriter >> xmlnsAt: aPrefix ifAbsentPut: aUriBlock [
	^ self xmlnsDeclarations at: aPrefix ifAbsentPut: aUriBlock
]

{ #category : #accessing }
XMLTagWriter >> xmlnsAt: aPrefix put: aValue [
	^ self xmlnsDeclarations at: aPrefix put: aValue
]

{ #category : #accessing }
XMLTagWriter >> xmlnsDeclarations [
	^ xmlnsDeclarations ifNil: [xmlnsDeclarations := OrderPreservingDictionary new: 5 withDefaultValue: '']
]

{ #category : #accessing }
XMLTagWriter >> xmlnsDeclarations: aDictionaryOrArray [
	"set xmlns decls using a dictionary or array of prefix/uri associations.
	empty prefix is default xmlns."
	(xmlnsDeclarations := OrderPreservingDictionary newFrom: aDictionaryOrArray)  defaultValue: ''
]
