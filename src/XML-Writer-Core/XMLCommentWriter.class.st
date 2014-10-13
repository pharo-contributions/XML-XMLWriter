"
Generates a comment; XMLWriter>>comment: should normally suffice.
"
Class {
	#name : #XMLCommentWriter,
	#superclass : #XMLEmbeddedMarkupWriter,
	#category : #'XML-Writer-Core'
}

{ #category : #private }
XMLCommentWriter >> writeBody: aStringOrCollectionOrBlock [
	self omitIfCanonicalInDTD: [super writeBody: aStringOrCollectionOrBlock]
]

{ #category : #private }
XMLCommentWriter >> writeEpilogue [
	self omitIfCanonicalInDTD: [self writer nextPutAll: '-->']
]

{ #category : #private }
XMLCommentWriter >> writePrologue [	
	self omitIfCanonicalInDTD: [
		self writer
			cr;
			nextPutAll: '<!--']
]
