Extension { #name : #OrderPreservingStringDictionary }

{ #category : #'*XML-Writer-Core' }
OrderPreservingStringDictionary >> writeAttributesOn: aTagWriter [
	self keysDo: [:attributeName |
		aTagWriter
			writeAttributeName: attributeName
			value: (self at: attributeName ifAbsent: '')]
]

{ #category : #'*XML-Writer-Core' }
OrderPreservingStringDictionary >> writeSortedAttributesOn: aTagWriter [
	self keys sort do: [:attributeName |
		aTagWriter
			writeAttributeName: attributeName
			value: (self at: attributeName ifAbsent: '')]
]
