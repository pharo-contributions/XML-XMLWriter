"
Writes ELEMENT declarations. 

"
Class {
	#name : #XMLElementDeclarationWriter,
	#superclass : #XMLMarkupDeclarationWriter,
	#instVars : [
		'contentModel'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLElementDeclarationWriter >> contentModel [
	^ contentModel ifNil: [contentModel := '']
]

{ #category : #accessing }
XMLElementDeclarationWriter >> contentModel: aContentModelString [
	contentModel := aContentModelString
]

{ #category : #accessing }
XMLElementDeclarationWriter >> declarationType [
	^ 'ELEMENT'
]

{ #category : #accessing }
XMLElementDeclarationWriter >> element [
	^ self name
]

{ #category : #accessing }
XMLElementDeclarationWriter >> element: aName [
	self name: aName
]

{ #category : #private }
XMLElementDeclarationWriter >> writeBody [
	self writer nextPutAll: self contentModel
]
