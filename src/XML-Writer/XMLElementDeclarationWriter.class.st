Class {
	#name : #XMLElementDeclarationWriter,
	#superclass : #XMLMarkupDeclarationWriter,
	#instVars : [
		'contentModel'
	],
	#category : #'XML-Writer'
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

{ #category : #private }
XMLElementDeclarationWriter >> writeBody [
	self writer nextPutAll: self contentModel
]
