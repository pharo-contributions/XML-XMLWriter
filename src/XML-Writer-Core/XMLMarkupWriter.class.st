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
	^ self new setWriter: aWriter
]

{ #category : #converting }
XMLMarkupWriter >> asString [
	"for GS compatibility"
	^ self printString
]

{ #category : #writing }
XMLMarkupWriter >> close [
	self writer close
]

{ #category : #accessing }
XMLMarkupWriter >> contents [
	^ self writer contents
]

{ #category : #writing }
XMLMarkupWriter >> finishWriting [
	self hasEmbeddedMarkupWriters
		ifTrue: [self writer writeUnwrittenMarkupWritersEmbeddedIn: self].
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
XMLMarkupWriter >> hasEmbeddedStringMarkup [
	^ false
]

{ #category : #testing }
XMLMarkupWriter >> isDoctypeWriter [
	^ false
]

{ #category : #testing }
XMLMarkupWriter >> isEmbeddedWithStringMarkup [
	| parent |

	^ (parent := self parentMarkupWriter) notNil
		and: [parent hasEmbeddedStringMarkup]
]

{ #category : #testing }
XMLMarkupWriter >> isTagWriter [
	^ false
]

{ #category : #testing }
XMLMarkupWriter >> isWriting [
	^ isWriting
]

{ #category : #private }
XMLMarkupWriter >> newMarkupWriterBeingPushed [
	self write
]

{ #category : #private }
XMLMarkupWriter >> newStringMarkupBeingWritten [
	self write
]

{ #category : #private }
XMLMarkupWriter >> omitIfCanonical: aBlock [
	self writer isCanonical
		ifFalse: [aBlock value]
]

{ #category : #private }
XMLMarkupWriter >> omitIfCanonicalInDTD: aBlock [
	| parent |

	(self writer isCanonical
		and: [(parent := self parentMarkupWriter) notNil
			and: [parent isDoctypeWriter]])
		ifFalse: [aBlock value]
]

{ #category : #accessing }
XMLMarkupWriter >> parentMarkupWriter [
	^ self writer parentMarkupWriterOf: self
]

{ #category : #printing }
XMLMarkupWriter >> printOn: aStream [
	self writer printOn: aStream
]

{ #category : #initialization }
XMLMarkupWriter >> setWriter: aWriter [
	writer := aWriter.
	isWriting := false.
]

{ #category : #writing }
XMLMarkupWriter >> startWriting [
	isWriting := true.
	self writePrologue.
]

{ #category : #writing }
XMLMarkupWriter >> write [
	self isWriting
		ifFalse: [
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
