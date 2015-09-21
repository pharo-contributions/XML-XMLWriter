"
A markup writer for <![CDATA[...]]> sections. Will be output as regular escpaed strings instead if isCanonical is enbaled.
"
Class {
	#name : #XMLCDataWriter,
	#superclass : #XMLMarkupWriter,
	#instVars : [
		'string'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLCDataWriter >> string [
	^ string ifNil: [string := '']
]

{ #category : #accessing }
XMLCDataWriter >> string: aString [
	string := aString
]

{ #category : #private }
XMLCDataWriter >> writeBody [
	self writer isCanonical
		ifTrue: [
			self parentMarkupWriter
				ifNotNil: [:parent | parent newStringMarkupBeingWritten].
			self writer writeEscapedContent: self string]
		ifFalse: [self writer nextPutAll: self string]
]

{ #category : #private }
XMLCDataWriter >> writeEpilogue [
	self omitIfCanonical: [
		self writer
			nextPutAll: ']]>';
			formatAfterCData: self]
]

{ #category : #private }
XMLCDataWriter >> writePrologue [
	self omitIfCanonical: [
		self writer
			formatBeforeCData: self;
			nextPutAll: '<![CDATA[']
]
