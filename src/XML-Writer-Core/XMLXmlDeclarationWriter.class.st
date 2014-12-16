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
XMLXmlDeclarationWriter >> standalone: aBooleanOrString [
	aBooleanOrString isString
		ifTrue: [standalone := aBooleanOrString = 'yes']
		ifFalse: [standalone := aBooleanOrString].
]

{ #category : #accessing }
XMLXmlDeclarationWriter >> version [
	^ version ifNil: [version := '1.0']
]

{ #category : #accessing }
XMLXmlDeclarationWriter >> version: aVersion [
	| versionString |

	version :=
		(versionString := (aVersion ifNil: ['1.0']) asString)
			copyFrom: 1 "avoid first: for portability"
			to: (3 min: versionString size)
]

{ #category : #private }
XMLXmlDeclarationWriter >> writeBody [
	self omitIfCanonical: [
		self writer
			space;
			writeName: 'version' unescapedValue: self version;
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
			formatBeforeXmlDeclaration: self;
			nextPutAll: '<?xml']
]
