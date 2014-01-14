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

{ #category : #testing }
XMLMarkupWriter >> hasEmbeddedMarkup [
	^ false
]

{ #category : #testing }
XMLMarkupWriter >> isEmbedded [
	^ self writer hasEmbeddedMarkupWriter: self
]

{ #category : #testing }
XMLMarkupWriter >> isWriting [
	^ isWriting ifNil: [isWriting := false]
]

{ #category : #printing }
XMLMarkupWriter >> printOn: aStream [
	self writer printOn: aStream
]

{ #category : #private }
XMLMarkupWriter >> startWriting [
	isWriting := true
]

{ #category : #private }
XMLMarkupWriter >> stopWriting [
	isWriting := false.
	self writer popActiveMarkupWriter.
]

{ #category : #'writing markup' }
XMLMarkupWriter >> write [
	self
		startWriting;
		writePrologue;
		writeBody;
		writeEpilogue;
		stopWriting
]

{ #category : #private }
XMLMarkupWriter >> writeBody [
]

{ #category : #private }
XMLMarkupWriter >> writeEpilogue [
]

{ #category : #private }
XMLMarkupWriter >> writeForNewMarkup [
	self write
]

{ #category : #private }
XMLMarkupWriter >> writeForNewMarkupWriter [
	self write
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
