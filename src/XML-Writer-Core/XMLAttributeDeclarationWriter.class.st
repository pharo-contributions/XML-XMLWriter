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
	defaultPragma :=
		(aDefaultPragma notNil
			and: [aDefaultPragma notEmpty
				and: [aDefaultPragma first == $#]])
			ifTrue: [aDefaultPragma allButFirst]
			ifFalse: [aDefaultPragma]
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
	self isOmittable
		ifTrue: [^ self].

	self writer
		writeName: self attribute;
		space;
		writeName: self type.

	self
		writeDefaultPragma;
		writeDefaultValue.
]

{ #category : #writing }
XMLAttributeDeclarationWriter >> writeDefaultPragma [
	self defaultPragma notEmpty
		ifTrue: [
			self writer
				space;
				nextPut: $#;
				nextPutAll: self defaultPragma]
]

{ #category : #writing }
XMLAttributeDeclarationWriter >> writeDefaultValue [
	(self defaultPragma isEmpty
		or: [self defaultPragma = 'FIXED'])
		ifTrue: [
			self writer
				space;
				writeEscapedContentString: self defaultValue]
]
