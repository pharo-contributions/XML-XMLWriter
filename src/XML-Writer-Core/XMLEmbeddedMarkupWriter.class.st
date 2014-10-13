"
This class is a markup writer that supports embedding of child markup.
"
Class {
	#name : #XMLEmbeddedMarkupWriter,
	#superclass : #XMLMarkupWriter,
	#instVars : [
		'hasEmbeddedMarkup',
		'hasEmbeddedMarkupWriters'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #private }
XMLEmbeddedMarkupWriter >> embedBlock: aBlock [
	aBlock cull: self writer
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> embedCollection: aCollection [
	aCollection do: [:each | self embedValue: each]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> embedString: aString [
	self prepareForEmbeddedMarkup.

	self escapesEmbeddedStrings
		ifTrue: [self writer writeEscapedContent: aString]
		ifFalse: [self writer nextPutAll: aString]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> embedValue: aValue [
	aValue isString
		ifTrue: [^ self embedString: aValue].
	aValue isCollection
		ifTrue: [^ self embedCollection: aValue].
	aValue isBlock
		ifTrue: [^ self embedBlock: aValue].

	self error: 'Value object must be a string, collection or block'.
]

{ #category : #testing }
XMLEmbeddedMarkupWriter >> escapesEmbeddedStrings [
	^ false
]

{ #category : #testing }
XMLEmbeddedMarkupWriter >> hasEmbeddedMarkup [
	^ hasEmbeddedMarkup ifNil: [hasEmbeddedMarkup := false]
]

{ #category : #testing }
XMLEmbeddedMarkupWriter >> hasEmbeddedMarkupWriters [
	^ hasEmbeddedMarkupWriters ifNil: [hasEmbeddedMarkupWriters := false]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> newMarkupBeingWritten [
	self isWriting
		ifTrue: [self prepareForEmbeddedMarkup]
		ifFalse: [self write]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> newMarkupWriterBeingPushed [
	self isWriting
		ifTrue: [
			self prepareForEmbeddedMarkup.
			hasEmbeddedMarkupWriters := true]
		ifFalse: [self write]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> prepareForEmbeddedMarkup [
	self hasEmbeddedMarkup
		ifFalse: [
			hasEmbeddedMarkup := true.
			self writeEmbeddedMarkupPrologue]
]

{ #category : #'embedding markup' }
XMLEmbeddedMarkupWriter >> with: aStringOrCollectionOrBlock [
	self isWriting ifFalse: [
		self
			startWriting;
			writeBody: aStringOrCollectionOrBlock;
			finishWriting]
]

{ #category : #'writing markup' }
XMLEmbeddedMarkupWriter >> writeBody [
	self writeBody: nil
]

{ #category : #'embedding markup' }
XMLEmbeddedMarkupWriter >> writeBody: aStringOrCollectionOrBlock [
	aStringOrCollectionOrBlock
		ifNotNil: [self embedValue: aStringOrCollectionOrBlock]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> writeEmbeddedMarkupPrologue [
]
