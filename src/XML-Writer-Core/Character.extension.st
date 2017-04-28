Extension { #name : #Character }

{ #category : #'*XML-Writer-Core' }
Character >> embedInXMLMarkupWriter: aMarkupWriter [
	self asString embedInXMLMarkupWriter: aMarkupWriter
]

{ #category : #'*XML-Writer-Core' }
Character >> isXMLWriterNameChar [
	"Range tests are faster and use less memory than a BitmapCharacterSet, and
	a temp is used because Character in newer SpurVM images has no 'value'
	inst var.
	
	NameStartChar ::=
		':' | [A-Z] | '_' | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] |
		[#x370-#x37D] | [#x37F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] |
		[#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] |
		[#x10000-#xEFFFF]
	NameChar ::=
		NameStartChar | '-' | '.' | [0-9] | #xB7 | [#x0300-#x036F] |
		[#x203F-#x2040]"

	| tempValue |

	(tempValue := self asciiValue) <= 16r7A "$z asciiValue hex"
		ifTrue: [
			tempValue >= 16r61 "$a asciiValue hex"
				ifTrue: [^ true].

			tempValue >= 16r41 "$A asciiValue hex"
				ifTrue: [
					tempValue <= 16r5A "$Z asciiValue hex"
						ifTrue: [^ true].
					^ tempValue == 16r5F]. "$_ asciiValue hex"

			tempValue >= 16r30 "$0 asciiValue hex"
				ifTrue: [
					tempValue <= 16r39 "$9 asciiValue hex"
						ifTrue: [^ true].
					^ tempValue == 16r3A]. "$: asciiValue hex"

			tempValue == 16r2E "$. asciiValue hex"
				ifTrue: [^ true].
			^ tempValue == 16r2D]. "$- asciiValue hex"

	tempValue >= 16rC0
		ifFalse: [^ tempValue == 16rB7].
	tempValue <= 16rD6
		ifTrue: [^ true].

	tempValue >= 16rD8
		ifFalse: [^ false].
	tempValue <= 16rF6
		ifTrue: [^ true].

	tempValue >= 16rF8
		ifFalse: [^ false].
	tempValue <= 16r2FF
		ifTrue: [^ true].

	tempValue >= 16r300
		ifFalse: [^ false].
	tempValue <= 16r36F
		ifTrue: [^ true].

	tempValue >= 16r370
		ifFalse: [^ false].
	tempValue <= 16r37D
		ifTrue: [^ true].

	tempValue >= 16r37F
		ifFalse: [^ false].
	tempValue <= 16r1FFF
		ifTrue: [^ true].

	tempValue >= 16r200C
		ifFalse: [^ false].
	tempValue <= 16r200D
		ifTrue: [^ true].

	tempValue >= 16r203F
		ifFalse: [^ false].
	tempValue <= 16r2040
		ifTrue: [^ true].

	tempValue >= 16r2070
		ifFalse: [^ false].
	tempValue <= 16r218F
		ifTrue: [^ true].

	tempValue >= 16r2C00
		ifFalse: [^ false].
	tempValue <= 16r2FEF
		ifTrue: [^ true].

	tempValue >= 16r3001
		ifFalse: [^ false].
	tempValue <= 16rD7FF
		ifTrue: [^ true].

	tempValue >= 16rF900
		ifFalse: [^ false].
	tempValue <= 16rFDCF
		ifTrue: [^ true].

	tempValue >= 16rFDF0
		ifFalse: [^ false].
	tempValue <= 16rFFFD
		ifTrue: [^ true].

	tempValue >= 16r10000
		ifFalse: [^ false].
	^ tempValue <= 16rEFFFF.
]

{ #category : #'*XML-Writer-Core' }
Character >> isXMLWriterNameStartChar [
	"Range tests are faster and use less memory than a BitmapCharacterSet, and
	a temp is used because Character in newer SpurVM images has no 'value'
	inst var.
	
	NameStartChar ::=
		':' | [A-Z] | '_' | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] |
		[#x370-#x37D] | [#x37F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] |
		[#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] |
		[#x10000-#xEFFFF]"

	| tempValue |

	(tempValue := self asciiValue) <= 16r7A "$z asciiValue hex"
		ifTrue: [
			tempValue >= 16r61 "$a asciiValue hex"
				ifTrue: [^ true].

			tempValue >= 16r41 "$A asciiValue hex"
				ifTrue: [
					tempValue <= 16r5A "$Z asciiValue hex"
						ifTrue: [^ true].
					^ tempValue == 16r5F]. "$_ asciiValue hex"
	
			^ tempValue == 16r3A]. "$: asciiValue hex"

	tempValue >= 16rC0
		ifFalse: [^ false].
	tempValue <= 16rD6
		ifTrue: [^ true].

	tempValue >= 16rD8
		ifFalse: [^ false].
	tempValue <= 16rF6
		ifTrue: [^ true].

	tempValue >= 16rF8
		ifFalse: [^ false].
	tempValue <= 16r2FF
		ifTrue: [^ true].

	tempValue >= 16r370
		ifFalse: [^ false].
	tempValue <= 16r37D
		ifTrue: [^ true].

	tempValue >= 16r37F
		ifFalse: [^ false].
	tempValue <= 16r1FFF
		ifTrue: [^ true].

	tempValue >= 16r200C
		ifFalse: [^ false].
	tempValue <= 16r200D
		ifTrue: [^ true].

	tempValue >= 16r2070
		ifFalse: [^ false].
	tempValue <= 16r218F
		ifTrue: [^ true].

	tempValue >= 16r2C00
		ifFalse: [^ false].
	tempValue <= 16r2FEF
		ifTrue: [^ true].

	tempValue >= 16r3001
		ifFalse: [^ false].
	tempValue <= 16rD7FF
		ifTrue: [^ true].

	tempValue >= 16rF900
		ifFalse: [^ false].
	tempValue <= 16rFDCF
		ifTrue: [^ true].

	tempValue >= 16rFDF0
		ifFalse: [^ false].
	tempValue <= 16rFFFD
		ifTrue: [^ true].

	tempValue >= 16r10000
		ifFalse: [^ false].
	^ tempValue <= 16rEFFFF.
]
