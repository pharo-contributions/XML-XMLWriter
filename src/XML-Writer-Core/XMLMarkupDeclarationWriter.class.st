"
This is an abstract class for DTD markup declaration writers.
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
	self isCanonical
		ifFalse: [
			self writer
				nextPut: $>;
				formatAfterDeclaration: self]
]

{ #category : #private }
XMLMarkupDeclarationWriter >> writePrologue [
	self isCanonical
		ifFalse: [
			self writer
				formatBeforeDeclaration: self;
				nextPutAll: '<!';
				writeName: self declarationType;
				space;
				writeName: self name;
				space]
]
