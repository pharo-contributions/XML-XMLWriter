"
This class generates <?xml ...?> declarations.
"
Class {
	#name : #XMLXmlDeclarationWriter,
	#superclass : #XMLMarkupWriter,
	#instVars : [
		'encoding',
		'version',
		'standalone'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLXmlDeclarationWriter >> encoding [
	^ encoding ifNil: [encoding := 'UTF-8']
]

{ #category : #accessing }
XMLXmlDeclarationWriter >> encoding: anEncoding [
	encoding := anEncoding
]

{ #category : #accessing }
XMLXmlDeclarationWriter >> standalone [
	^ standalone ifNil: [standalone := false]
]

{ #category : #accessing }
XMLXmlDeclarationWriter >> standalone: aBoolean [
	standalone := aBoolean
]

{ #category : #accessing }
XMLXmlDeclarationWriter >> version [
	^ version ifNil: [version := '1.0']
]

{ #category : #accessing }
XMLXmlDeclarationWriter >> version: aVersion [
	version := aVersion
]

{ #category : #private }
XMLXmlDeclarationWriter >> writeBody [
	self omitIfCanonical: [
		self writer
			writeName: 'version' unescapedValue: self version asString;
			space;
			writeName: 'encoding' unescapedValue: self encoding.

		self standalone
			ifTrue: [
				self writer
					space;
					writeName: 'standalone' unescapedValue: 'yes']]
]

{ #category : #private }
XMLXmlDeclarationWriter >> writeEpilogue [
	self omitIfCanonical: [self writer nextPutAll: '?>']
]

{ #category : #private }
XMLXmlDeclarationWriter >> writePrologue [
	self omitIfCanonical: [
		self writer
			cr;
			nextPutAll: '<?xml']
]
