"
This class generates a <![CDATA[...]]> section. If the XMLWriter object has been set to generate canonical XML, CDATA sections will not be produced and their content will instead be XML-escaped and inserted directly into the document.
"
Class {
	#name : #XMLCDataWriter,
	#superclass : #XMLEmbeddedMarkupWriter,
	#category : #'XML-Writer-Core'
}

{ #category : #testing }
XMLCDataWriter >> encodesEmbeddedStrings [
	^ self writer isCanonical
]

{ #category : #private }
XMLCDataWriter >> writeEpilogue [
	self writer isCanonical
		ifFalse: [self writer nextPutAll: ']]>']
]

{ #category : #private }
XMLCDataWriter >> writePrologue [
	self writer isCanonical
		ifFalse: [self writer nextPutAll: '<![CDATA[']
]
