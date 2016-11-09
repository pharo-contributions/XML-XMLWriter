"
This class writes XML <!-- ... --> comments, but not in DTD internal subsets if canonical XML is enabled.
"
Class {
	#name : #XMLCommentWriter,
	#superclass : #XMLMarkupWriter,
	#instVars : [
		'string'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLCommentWriter >> string [
	^ string ifNil: [string := '']
]

{ #category : #accessing }
XMLCommentWriter >> string: aString [
	string := aString
]

{ #category : #private }
XMLCommentWriter >> writeBody [
	self isCanonicalInDTD
		ifFalse: [self writer nextPutAll: self string]
]

{ #category : #private }
XMLCommentWriter >> writeEpilogue [
	self isCanonicalInDTD
		ifFalse: [
			self writer
				nextPutAll: '-->';
				formatAfterComment: self]
]

{ #category : #private }
XMLCommentWriter >> writePrologue [
	self isCanonicalInDTD
		ifFalse: [
			self writer
				formatBeforeComment: self;
				nextPutAll: '<!--']
]
