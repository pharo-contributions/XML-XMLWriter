"
This class writes <!DOCTYPE ...> declarations. You can set the root element, public ID and system ID using the messages under ""accessing"" before specifying any internal subset with #internalSubset: (which results in the declaration being written). If no public ID is supplied, then the declaration written will be of type ""SYSTEM"" rather than ""PUBLIC"" and will not have any Formal Public Identifier (FPI). The internal subset, if supplied, should consist of markup declarations generated with instances of XMLMarkupDeclarationWriter subclasses.
"
Class {
	#name : #XMLDoctypeDeclarationWriter,
	#superclass : #XMLEmbeddedMarkupWriter,
	#instVars : [
		'root',
		'externalIdWriter'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLDoctypeDeclarationWriter >> externalIDWriter [
	^ externalIdWriter ifNil: [externalIdWriter := XMLExternalIDWriter new]
]

{ #category : #testing }
XMLDoctypeDeclarationWriter >> isDoctypeWriter [
	^ true
]

{ #category : #accessing }
XMLDoctypeDeclarationWriter >> publicID [
	^ self externalIDWriter publicID
]

{ #category : #accessing }
XMLDoctypeDeclarationWriter >> publicID: aPublicId [
	self externalIDWriter publicID: aPublicId
]

{ #category : #accessing }
XMLDoctypeDeclarationWriter >> root [
	^ root ifNil: ['']
]

{ #category : #accessing }
XMLDoctypeDeclarationWriter >> root: aRootElementName [
	root := aRootElementName
]

{ #category : #accessing }
XMLDoctypeDeclarationWriter >> systemID [
	^ self externalIDWriter systemID
]

{ #category : #accessing }
XMLDoctypeDeclarationWriter >> systemID: aSystemId [
	self externalIDWriter systemID: aSystemId
]

{ #category : #'embedding markup' }
XMLDoctypeDeclarationWriter >> withInternalSubset: aStringOrCollectionOrBlock [
	^ self with: aStringOrCollectionOrBlock
]

{ #category : #'embedding markup' }
XMLDoctypeDeclarationWriter >> writeBody: aStringOrCollectionOrBlock [
	self omitIfCanonical: [super writeBody: aStringOrCollectionOrBlock]
]

{ #category : #private }
XMLDoctypeDeclarationWriter >> writeEmbeddedMarkupPrologue [
	self omitIfCanonical: [
		self writer
			space;
			nextPut: $[;
			formatBeforeInternalSubset: self]
]

{ #category : #private }
XMLDoctypeDeclarationWriter >> writeEpilogue [
	self omitIfCanonical: [
		self hasEmbeddedMarkup
			ifTrue: [
				self writer
					formatAfterInternalSubset: self;
					nextPut: $]].
		self writer
			nextPut: $>;
			formatAfterDoctypeDeclaration: self]
]

{ #category : #private }
XMLDoctypeDeclarationWriter >> writePrologue [
	self omitIfCanonical: [
		self writer
			formatBeforeDoctypeDeclaration: self;
			nextPutAll: '<!DOCTYPE';
			space;
			writeName: self root.

		self externalIDWriter hasExternalID
			ifTrue: [
				self writer space.
				self externalIDWriter writeOn: self writer]]
]
