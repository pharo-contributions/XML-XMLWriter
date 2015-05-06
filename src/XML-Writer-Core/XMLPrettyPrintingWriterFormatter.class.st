"
A formatter that inserts ignorable whitespace to make the XML more readable.
"
Class {
	#name : #XMLPrettyPrintingWriterFormatter,
	#superclass : #XMLWriterFormatter,
	#category : #'XML-Writer-Core'
}

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatAfterDoctypeDeclaration: aDoctypeDeclarationWriter [
	self writeLineBreak
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatAfterInternalSubset: aDoctypeDeclarationWriter [
	aDoctypeDeclarationWriter hasEmbeddedMarkup
		ifTrue: [
			self
				outdent;
				writeLineBreak]
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatAfterStartTag: aTagWriter [
	self indent
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatBeforeComment: aCommentWriter [
	aCommentWriter isEmbeddedWithStringMarkup
		ifFalse: [self writeLineBreak]
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatBeforeDeclaration: aDeclarationWriter [
	self writeLineBreak
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatBeforeDoctypeDeclaration: aDoctypeDeclarationWriter [
	self writeLineBreak
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatBeforeEndTag: aTagWriter [
	aTagWriter hasEmbeddedMarkup
		ifTrue: [
			self outdent.
			aTagWriter hasEmbeddedStringMarkup
				ifFalse: [self writeLineBreak]]
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatBeforeEntityReference: anEntityReferenceWriter [
	anEntityReferenceWriter isParameter
		ifTrue: [self writeLineBreak]
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatBeforeInternalSubset: aDoctypeDeclarationWriter [
	self indent
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatBeforePI: aPiWriter [
	aPiWriter isEmbeddedWithStringMarkup
		ifFalse: [self writeLineBreak]
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatBeforeStartTag: aTagWriter [
	aTagWriter isEmbeddedWithStringMarkup
		ifFalse: [self writeLineBreak]
]

{ #category : #formatting }
XMLPrettyPrintingWriterFormatter >> formatBeforeXMLDeclaration: anXMLDeclarationWriter [
	self writeLineBreak
]
