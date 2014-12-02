"
This is a generic superclass for classes that generate DTD markup declarations--ELEMENT, ATTLIST, ENTITY and so on.
"
Class {
	#name : #XMLMarkupDeclarationWriter,
	#superclass : #XMLMarkupWriter,
	#instVars : [
		'name'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLMarkupDeclarationWriter >> declarationType [
	self subclassResponsibility
]

{ #category : #accessing }
XMLMarkupDeclarationWriter >> name [
	^ name ifNil: ['']
]

{ #category : #accessing }
XMLMarkupDeclarationWriter >> name: aName [
	name := aName
]

{ #category : #private }
XMLMarkupDeclarationWriter >> writeEpilogue [
	self omitIfCanonical: [self writer nextPut: $>]
]

{ #category : #private }
XMLMarkupDeclarationWriter >> writePrologue [
	self omitIfCanonical: [
		self writer
			formatBeforeDeclaration: self;
			nextPutAll: '<!';
			writeName: self declarationType;
			space;
			writeName: self name;
			space]
]
