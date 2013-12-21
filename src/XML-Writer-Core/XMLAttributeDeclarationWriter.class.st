Class {
	#name : #XMLAttributeDeclarationWriter,
	#superclass : #XMLMarkupDeclarationWriter,
	#instVars : [
		'attribute',
		'type',
		'defaultDeclaration'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLAttributeDeclarationWriter >> attribute [
	^ attribute ifNil: [attribute := '']
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> attribute: aName [
	attribute := aName
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> declarationType [
	^ 'ATTLIST'
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> defaultDeclaration [
	^ defaultDeclaration ifNil: [defaultDeclaration := '']
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> defaultDeclaration: aDefaultDeclaration [
	defaultDeclaration := aDefaultDeclaration
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> element [
	^ self name
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> element: aName [
	self name: aName
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> type [
	^ type ifNil: [type := 'CDATA']
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> type: aType [
	type := aType
]

{ #category : #private }
XMLAttributeDeclarationWriter >> writeBody [
	self writer
		writeName: self attribute;
		space;
		writeName: self type.

	self defaultDeclaration
		ifNotEmpty: [
			self writer
				space;
				nextPutAll: self defaultDeclaration]
]
