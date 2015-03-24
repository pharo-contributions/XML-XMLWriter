"
This class generates <?xml ...?> declarations.
"
Class {
	#name : #XMLXMLDeclarationWriter,
	#superclass : #XMLMarkupWriter,
	#instVars : [
		'encoding',
		'version',
		'standalone'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLXMLDeclarationWriter >> encoding [
	^ encoding ifNil: [encoding := 'UTF-8']
]

{ #category : #accessing }
XMLXMLDeclarationWriter >> encoding: anEncoding [
	encoding := anEncoding
]

{ #category : #accessing }
XMLXMLDeclarationWriter >> standalone [
	^ standalone ifNil: [standalone := false]
]

{ #category : #accessing }
XMLXMLDeclarationWriter >> standalone: aBooleanOrString [
	aBooleanOrString isString
		ifTrue: [standalone := aBooleanOrString = 'yes']
		ifFalse: [standalone := aBooleanOrString].
]

{ #category : #accessing }
XMLXMLDeclarationWriter >> version [
	^ version ifNil: [version := '1.0']
]

{ #category : #accessing }
XMLXMLDeclarationWriter >> version: aVersion [
	| versionString |

	version := "avoid first: for portability"
		(versionString := (aVersion ifNil: ['1.0']) asString)
			copyFrom: 1
			to: (3 min: versionString size)
]

{ #category : #private }
XMLXMLDeclarationWriter >> writeBody [
	self omitIfCanonical: [
		self writer
			space;
			writeName: 'version'
			unescapedValue: (self version ifEmpty: ['1.0']).
		self encoding
			ifNotEmpty: [:encodingName |
				self writer
					space;
					writeName: 'encoding'
					unescapedValue: encodingName].
		self standalone
			ifTrue: [
				self writer
					space;
					writeName: 'standalone' unescapedValue: 'yes']]
]

{ #category : #private }
XMLXMLDeclarationWriter >> writeEpilogue [
	self omitIfCanonical: [self writer nextPutAll: '?>']
]

{ #category : #private }
XMLXMLDeclarationWriter >> writePrologue [
	self omitIfCanonical: [
		self writer
			formatBeforeXMLDeclaration: self;
			nextPutAll: '<?xml']
]
