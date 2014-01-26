Class {
	#name : #XMLNotationDeclarationWriter,
	#superclass : #XMLMarkupDeclarationWriter,
	#instVars : [
		'externalIdWriter'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLNotationDeclarationWriter >> declarationType [
	^ 'NOTATION'
]

{ #category : #accessing }
XMLNotationDeclarationWriter >> externalIDWriter [
	^ externalIdWriter ifNil: [externalIdWriter := XMLExternalIDWriter new]
]

{ #category : #accessing }
XMLNotationDeclarationWriter >> publicID [
	^ self externalIDWriter publicID
]

{ #category : #accessing }
XMLNotationDeclarationWriter >> publicID: aPublic [
	self externalIDWriter publicID: aPublic
]

{ #category : #accessing }
XMLNotationDeclarationWriter >> systemID [
	^ self externalIDWriter systemID
]

{ #category : #accessing }
XMLNotationDeclarationWriter >> systemID: aSystemId [
	self externalIDWriter systemID: aSystemId
]

{ #category : #private }
XMLNotationDeclarationWriter >> writeBody [
	self externalIDWriter writeOn: self writer
]
