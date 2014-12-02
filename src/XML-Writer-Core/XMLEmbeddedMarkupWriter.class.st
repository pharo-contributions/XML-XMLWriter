"
This class is a markup writer that supports embedding of child markup.
"
Class {
	#name : #XMLEmbeddedMarkupWriter,
	#superclass : #XMLMarkupWriter,
	#instVars : [
		'hasEmbeddedStringMarkup',
		'hasEmbeddedMarkupWriters'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #testing }
XMLEmbeddedMarkupWriter >> hasEmbeddedMarkup [
	^ hasEmbeddedStringMarkup | hasEmbeddedMarkupWriters
]

{ #category : #testing }
XMLEmbeddedMarkupWriter >> hasEmbeddedMarkupWriters [
	^ hasEmbeddedMarkupWriters
]

{ #category : #testing }
XMLEmbeddedMarkupWriter >> hasEmbeddedStringMarkup [
	^ hasEmbeddedStringMarkup
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> newMarkupWriterBeingPushed [
	self isWriting
		ifTrue: [
			self hasEmbeddedMarkup
				ifFalse: [self writeEmbeddedMarkupPrologue].
			hasEmbeddedMarkupWriters := true]
		ifFalse: [self write]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> newStringMarkupBeingWritten [
	self isWriting
		ifTrue: [
			self hasEmbeddedMarkup
				ifFalse: [self writeEmbeddedMarkupPrologue].
			hasEmbeddedStringMarkup := true]
		ifFalse: [self write]
]

{ #category : #initialization }
XMLEmbeddedMarkupWriter >> setWriter: aWriter [
	super setWriter: aWriter.

	hasEmbeddedStringMarkup := false.
	hasEmbeddedMarkupWriters := false.
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
	aStringOrCollectionOrBlock embedInMarkupWriter: self
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> writeEmbeddedMarkupPrologue [
]
