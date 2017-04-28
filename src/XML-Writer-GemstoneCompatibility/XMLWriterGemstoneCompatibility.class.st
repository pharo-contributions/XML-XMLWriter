"
Used in development to copy String extension methods to CharacterCollection.
"
Class {
	#name : #XMLWriterGemstoneCompatibility,
	#superclass : #Object,
	#category : #'XML-Writer-GemstoneCompatibility'
}

{ #category : #private }
XMLWriterGemstoneCompatibility class >> copyXMLGSExtensionMethods [
	"
	self copyXMLGSExtensionMethods
	"
	(String selectorsInProtocol: #'*XML-Writer-Core') do: [:each |
		CharacterCollection
			compile: (String sourceCodeAt: each)
			classified: #'*XML-Writer-GemstoneCompatibility'].
]
