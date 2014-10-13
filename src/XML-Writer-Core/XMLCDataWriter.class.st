"
This class generates a <![CDATA[...]]> section. If the XMLWriter object has been set to generate canonical XML, CDATA sections will not be produced and their content will instead be XML-escaped and inserted directly into the document.
"
Class {
	#name : #XMLCDataWriter,
	#superclass : #XMLEmbeddedMarkupWriter,
	#category : #'XML-Writer-Core'
}

{ #category : #testing }
XMLCDataWriter >> escapesEmbeddedStrings [
	^ self writer isCanonical
]

{ #category : #private }
XMLCDataWriter >> writeEpilogue [
	self omitIfCanonical: [self writer nextPutAll: ']]>']
]

{ #category : #private }
XMLCDataWriter >> writePrologue [
	self omitIfCanonical: [self writer nextPutAll: '<![CDATA[']
]
