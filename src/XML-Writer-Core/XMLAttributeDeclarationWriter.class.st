Class {
	#name : #XMLAttributeDeclarationWriter,
	#superclass : #XMLMarkupDeclarationWriter,
	#instVars : [
		'attribute',
		'type',
		'defaultPragma',
		'defaultValue'
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
XMLAttributeDeclarationWriter >> defaultPragma [
	^ defaultPragma ifNil: [defaultPragma := '']
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> defaultPragma: aDefaultPragma [
	defaultPragma := aDefaultPragma
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> defaultValue [
	^ defaultValue ifNil: [defaultValue := '']
]

{ #category : #accessing }
XMLAttributeDeclarationWriter >> defaultValue: aDefaultValue [
	defaultValue := aDefaultValue
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

	self defaultPragma
		ifNotEmpty: [
			self writer space.
			(self defaultPragma first == $#)
				ifFalse: [self writer nextPut: $#].
			self writer nextPutAll: self defaultPragma].

	self defaultValue
		ifNotEmpty: [
			self writer
				space;
				writeXmlEncodedString: self defaultValue].
]
