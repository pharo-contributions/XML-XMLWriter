"
This class generates XML tags for elements. You can specifiy the attributes of the start tag using the #attribute* messages, and you can add xmlns: namespace declarations using the #xmlns* messages. If you do not send #with:, or if you do but the argument is nil or a block that generates no markup, then only a single, empty tag in the form of ""<empty />"" will be generated, unless the writer object that created the tag writer object is configured to generate canonical XML, in which case an empty start/end tag pair like ""<empty></empty>"" will be generated.

You can supply child markup content using #with:. Namespace declarations will be ignored if a parent element has equivalent declarations (and they were thus already generated).
"
Class {
	#name : #XMLTagWriter,
	#superclass : #XMLEmbeddedMarkupWriter,
	#instVars : [
		'name',
		'xmlnsDeclarations',
		'attributes'
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
	^ attributes ifNil: [attributes := OrderPreservingStringDictionary new]
]

{ #category : #accessing }
XMLTagWriter >> attributes: aDictionaryOrArray [
	attributes := OrderPreservingStringDictionary newFrom: aDictionaryOrArray
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
XMLTagWriter >> setAttributes: aDictionary [
	attributes := aDictionary
]

{ #category : #initialization }
XMLTagWriter >> setXMLNSDeclarations: aDictionary [ 
	xmlnsDeclarations := aDictionary
]

{ #category : #private }
XMLTagWriter >> writeAttributeName: aName value: aValue [ 
	self writer
		space;
		writeName: aName
		escapedContentValue: aValue
]

{ #category : #private }
XMLTagWriter >> writeAttributes [
	attributes
		ifNotNil: [
			self writer isCanonical
				ifTrue: [attributes writeSortedAttributesOn: self]
				ifFalse: [attributes writeAttributesOn: self]]
]

{ #category : #private }
XMLTagWriter >> writeEmbeddedMarkupPrologue [
	self writer
		nextPut: $>;
		formatAfterStartTag: self
]

{ #category : #private }
XMLTagWriter >> writeEndTag [
	self writer
		formatBeforeEndTag: self;
		nextPut: $<;
		nextPut: $/;
		writeName: self name;
		nextPut: $>;
		formatAfterEndTag: self
]

{ #category : #private }
XMLTagWriter >> writeEpilogue [
	self hasEmbeddedMarkup
		ifTrue: [self writeEndTag]
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
						nextPut: $>;
						formatAfterEndTag: self]].
]

{ #category : #private }
XMLTagWriter >> writePrologue [
	self writer
		formatBeforeStartTag: self;
		nextPut: $<;
		writeName: self name.
	self
		writeXMLNSDeclarations;
		writeAttributes.
]

{ #category : #private }
XMLTagWriter >> writeXMLNS: aPrefix uri: aURI [
	self writer
		space;
		writeName:
			(aPrefix isEmpty
				ifTrue: ['xmlns']
				ifFalse: ['xmlns:', aPrefix])
		escapedContentValue: aURI
]

{ #category : #private }
XMLTagWriter >> writeXMLNSDeclarations [
	| checkForDuplicates parentMarkupWriter |

	xmlnsDeclarations
		ifNil: [^ self].
	checkForDuplicates := 
		self writer omitsRedundantXMLNSDeclarations
			and: [(parentMarkupWriter := self parentMarkupWriter) notNil
				and: [parentMarkupWriter isTagWriter]].
	self writer isCanonical
		ifTrue: [
			(xmlnsDeclarations keys reject: [:prefix |
				(checkForDuplicates
					and: [parentMarkupWriter xmlnsAt: prefix]) = (xmlnsDeclarations at: prefix)])
				sort;
				do: [:prefix |
					self
						writeXMLNS: prefix
						uri: (xmlnsDeclarations at: prefix)]]
		ifFalse: [
			xmlnsDeclarations keysDo: [:prefix | | uri |
				uri := xmlnsDeclarations at: prefix.
				(checkForDuplicates
					and: [(parentMarkupWriter xmlnsAt: prefix) = uri])
					ifFalse: [
						self
							writeXMLNS: prefix
							uri: uri]]].
]

{ #category : #accessing }
XMLTagWriter >> xmlns [
	"default namespace"
	^ self xmlnsDeclarations at: ''
]

{ #category : #accessing }
XMLTagWriter >> xmlns: aURI [
	"set default namespace"
	self xmlnsDeclarations at: '' put: aURI
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
	^ xmlnsDeclarations
		ifNil: [xmlnsDeclarations := OrderPreservingStringDictionary new: 5]
]

{ #category : #accessing }
XMLTagWriter >> xmlnsDeclarations: aDictionaryOrArray [
	"set xmlns decls using a dictionary or array of prefix/uri associations.
	empty prefix is default xmlns."
	xmlnsDeclarations := OrderPreservingStringDictionary newFrom: aDictionaryOrArray
]
