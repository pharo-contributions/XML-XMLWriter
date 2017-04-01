"
This class writes <?...?> processing instructions, but not in DTD internal subsets if canonical XML is enabled.
"
Class {
	#name : #XMLPIWriter,
	#superclass : #XMLMarkupWriter,
	#instVars : [
		'target',
		'data'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLPIWriter >> data [
	^ data ifNil: ['']
]

{ #category : #accessing }
XMLPIWriter >> data: aString [
	data := aString
]

{ #category : #testing }
XMLPIWriter >> hasData [
	^ self data notEmpty
]

{ #category : #testing }
XMLPIWriter >> isOmittable [
	^ self isCanonical
		and: [self isEmbeddedInDoctypeDeclaration]
]

{ #category : #accessing }
XMLPIWriter >> target [
	^ target ifNil: ['']
]

{ #category : #accessing }
XMLPIWriter >> target: aString [
	target := aString
]

{ #category : #private }
XMLPIWriter >> writeBody [
	| quotedStringStart quote |

	(self isOmittable
		or: [self hasData not])
		ifTrue: [^ self].

	self writer space.
	1 to: data size do: [:i | | nextChar |
		nextChar := data at: i.
		quotedStringStart
			ifNil: [
				(nextChar == $"
					or: [nextChar == $'])
					ifTrue: [
						quote := nextChar.
						quotedStringStart := i]
					ifFalse: [self writer nextPut: nextChar]]
			ifNotNil: [
				nextChar == quote
					ifTrue: [| quotedStringValue |
						quotedStringValue :=
							data
								copyFrom: quotedStringStart + 1
								to: i - 1.
						"do not use #writeUnescapedString: here to preserve the exact
						quote char used, because PIs can contain arbitrary data"
						self writer
							nextPut: quote;
							formatBeforeQuotedStringValue: quotedStringValue;
							nextPutAll: quotedStringValue;
							formatAfterQuotedStringValue: quotedStringValue;
							nextPut: quote.
						quotedStringStart := nil]]].

	"allow unterminated strings, because PIs can contain arbitrary data"
	quotedStringStart
		ifNotNil: [
			quotedStringStart to: data size do: [:i |
				self writer nextPut: (data at: i)]].
]

{ #category : #private }
XMLPIWriter >> writeEpilogue [
	self isOmittable
		ifFalse: [
			self writer
				nextPutAll: '?>';
				formatAfterPI: self]
]

{ #category : #private }
XMLPIWriter >> writePrologue [
	self isOmittable
		ifFalse: [
			self writer
				formatBeforePI: self;
				nextPutAll: '<?';
				writeName: self target]
]
