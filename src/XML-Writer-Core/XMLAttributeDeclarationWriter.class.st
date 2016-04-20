"
This class writes attribute <!ATTLIST ...> declarations for DTD internal subsets, but not if canonical XML is enabled.
"
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
	self omitIfCanonical: [
		self writer
			writeName: self attribute;
			space;
			writeName: self type.

		self
			writeDefaultPragma;
			writeDefaultValue]
]

{ #category : #private }
XMLAttributeDeclarationWriter >> writeDefaultPragma [
	self defaultPragma
		ifNotEmpty: [:pragma |
			self writer space.

			(pragma first == $#)
				ifFalse: [self writer nextPut: $#].

			self writer nextPutAll: pragma]
]

{ #category : #private }
XMLAttributeDeclarationWriter >> writeDefaultValue [
	self defaultValue
		ifNotEmpty: [:value |
			self writer
				space;
				writeEscapedContentString: value]
]
