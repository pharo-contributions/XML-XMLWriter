Extension { #name : #OrderPreservingStringDictionary }

{ #category : #'*XML-Writer-Core' }
OrderPreservingStringDictionary >> writeAttributesOn: aWriter [
	self keysDo: [:attributeName |
		aWriter
			writeAttributeName: attributeName
			value: (self at: attributeName ifAbsent: '')]
]

{ #category : #'*XML-Writer-Core' }
OrderPreservingStringDictionary >> writeSortedAttributesOn: aWriter [
	self keys sort do: [:attributeName |
		aWriter
			writeAttributeName: attributeName
			value: (self at: attributeName ifAbsent: '')]
]
