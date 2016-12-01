"
This class writes <?xml ...?> declarations, but not if canonical XML is enabled.
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
	^ encoding ifNil: [encoding := '']
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
	(version isNil
		or: [version isEmpty])
		ifTrue: [version := '1.0'].
	^ version.
]

{ #category : #accessing }
XMLXMLDeclarationWriter >> version: aVersionFloatOrString [
	| versionString |

	versionString := (aVersionFloatOrString ifNil: ['1.0']) asString.
	"cutoff excess digits without first: for GS portability"
	version :=
		versionString
			copyFrom: 1
			to: (3 min: versionString size)
]

{ #category : #private }
XMLXMLDeclarationWriter >> writeBody [
	self isCanonical
		ifTrue: [^ self].

	self writer
		space;
		writeName: 'version' unescapedValue: self version.

	self encoding isEmpty
		ifFalse: [
			self writer
				space;
				writeName: 'encoding' unescapedValue: self encoding].

	self standalone
		ifTrue: [
			self writer
				space;
				writeName: 'standalone' unescapedValue: 'yes'].
]

{ #category : #private }
XMLXMLDeclarationWriter >> writeEpilogue [
	self isCanonical
		ifFalse: [
			self writer
				nextPutAll: '?>';
				formatAfterXMLDeclaration: self]
]

{ #category : #private }
XMLXMLDeclarationWriter >> writePrologue [
	self isCanonical
		ifFalse: [
			self writer
				formatBeforeXMLDeclaration: self;
				nextPutAll: '<?xml']
]
