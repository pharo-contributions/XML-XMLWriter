"
This is a base class for markup writers. Subclasses override messages like #writePrologue and #writeEpilogue to write markup using the supplied XMLWriter object.
"
Class {
	#name : #XMLMarkupWriter,
	#superclass : #Object,
	#instVars : [
		'writer',
		'isWriting'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #'instance creation' }
XMLMarkupWriter class >> writer: aWriter [
	^ self new writer: aWriter
]

{ #category : #'writing markup' }
XMLMarkupWriter >> finishWriting [
	self hasEmbeddedMarkupWriters
		ifTrue: [self writer writeUnwrittenMarkupWriterEmbeddedIn: self].
	self writeEpilogue.
	isWriting := false.

	self writer popActiveMarkupWriter.
]

{ #category : #testing }
XMLMarkupWriter >> hasEmbeddedMarkup [
	^ false
]

{ #category : #testing }
XMLMarkupWriter >> hasEmbeddedMarkupWriters [
	^ false
]

{ #category : #testing }
XMLMarkupWriter >> isDoctypeWriter [
	^ false
]

{ #category : #testing }
XMLMarkupWriter >> isEmbedded [
	^ self writer hasEmbeddedMarkupWriter: self
]

{ #category : #testing }
XMLMarkupWriter >> isTagWriter [
	^ false
]

{ #category : #testing }
XMLMarkupWriter >> isWriting [
	^ isWriting ifNil: [isWriting := false]
]

{ #category : #private }
XMLMarkupWriter >> newMarkupBeingWritten [
	self write
]

{ #category : #private }
XMLMarkupWriter >> newMarkupWriterBeingPushed [
	self write
]

{ #category : #private }
XMLMarkupWriter >> omitIfCanonical: aBlock [
	self writer isCanonical
		ifFalse: [aBlock value]
]

{ #category : #private }
XMLMarkupWriter >> omitIfCanonicalInDTD: aBlock [
	(self writer isCanonical
		and: [self isEmbedded
			and: [self writer activeDoctypeWriter notNil]])
		ifFalse: [aBlock value]
]

{ #category : #printing }
XMLMarkupWriter >> printOn: aStream [
	self writer printOn: aStream
]

{ #category : #'writing markup' }
XMLMarkupWriter >> startWriting [
	isWriting := true.
	self writePrologue.
]

{ #category : #'writing markup' }
XMLMarkupWriter >> write [
	self isWriting ifFalse: [
		self
			startWriting;
			writeBody;
			finishWriting]
]

{ #category : #private }
XMLMarkupWriter >> writeBody [
]

{ #category : #private }
XMLMarkupWriter >> writeEpilogue [
]

{ #category : #private }
XMLMarkupWriter >> writePrologue [
]

{ #category : #accessing }
XMLMarkupWriter >> writer [
	^ writer
]

{ #category : #accessing }
XMLMarkupWriter >> writer: aWriter [
	writer := aWriter
]
