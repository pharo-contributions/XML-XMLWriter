"
An abstract class for formatters used to decorate markup writers.
"
Class {
	#name : #XMLWriterFormatter,
	#superclass : #Object,
	#instVars : [
		'writer',
		'indentString',
		'currentIndentLevel'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #'instance creation' }
XMLWriterFormatter class >> writer: anXmlWriter [
	^ self new setWriter: anXmlWriter
]

{ #category : #private }
XMLWriterFormatter >> currentIndentLevel [
	^ currentIndentLevel
]

{ #category : #private }
XMLWriterFormatter >> defaultIndentLevel [
	^ 0
]

{ #category : #private }
XMLWriterFormatter >> defaultIndentString [
	^ '    '
]

{ #category : #formatting }
XMLWriterFormatter >> formatAfterDoctypeDeclaration: aDoctypeDeclarationWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatAfterInternalSubset: aDoctypeDeclarationWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatAfterStartTag: aTagWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatBeforeComment: aCommentWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatBeforeDeclaration: aDeclarationWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatBeforeDoctypeDeclaration: aDoctypeDeclarationWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatBeforeEndTag: aTagWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatBeforeEntityReference: anEntityReferenceWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatBeforeInternalSubset: aDoctypeDeclarationWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatBeforePI: aPiWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatBeforeStartTag: aTagWriter [
]

{ #category : #formatting }
XMLWriterFormatter >> formatBeforeXmlDeclaration: anXmlDeclarationWriter [
]

{ #category : #private }
XMLWriterFormatter >> indent [
	currentIndentLevel := self currentIndentLevel + 1
]

{ #category : #accessing }
XMLWriterFormatter >> indentString [
	^ indentString
]

{ #category : #accessing }
XMLWriterFormatter >> indentString: aString [
	currentIndentLevel := 0.
	indentString := aString.
]

{ #category : #private }
XMLWriterFormatter >> outdent [
	currentIndentLevel := self currentIndentLevel - 1
]

{ #category : #initialization }
XMLWriterFormatter >> setWriter: anXmlWriter [
	writer := anXmlWriter.
	currentIndentLevel := self defaultIndentLevel.
	indentString := self defaultIndentString.
]

{ #category : #private }
XMLWriterFormatter >> writeIndent [
	1 to: self currentIndentLevel do: [:i |
		self writer nextPutAll: self indentString]
]

{ #category : #private }
XMLWriterFormatter >> writeLineBreak [
	self writer atStart
		ifFalse: [
			self writer nextPutAll: self writer lineBreak.
			self writeIndent]
]

{ #category : #accessing }
XMLWriterFormatter >> writer [
	^ writer
]
