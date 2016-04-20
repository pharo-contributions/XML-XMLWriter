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
	self omitIfCanonicalInDTD: [self writer nextPutAll: self string]
]

{ #category : #private }
XMLCommentWriter >> writeEpilogue [
	self omitIfCanonicalInDTD: [
		self writer
			nextPutAll: '-->';
			formatAfterComment: self]
]

{ #category : #private }
XMLCommentWriter >> writePrologue [
	self omitIfCanonicalInDTD: [
		self writer
			formatBeforeComment: self;
			nextPutAll: '<!--']
]
