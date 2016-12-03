Extension { #name : #OrderPreservingStringDictionary }

{ #category : #'*XML-Writer-Core' }
OrderPreservingStringDictionary >> writeAttributesOn: aWriter [
	self keysDo: [:attributeName |
		aWriter
			writeAttributeName: attributeName
			value: (self at: attributeName ifAbsent: '')]
]

{ #category : #'*XML-Writer-Core' }
OrderPreservingStringDictionary >> writeCanonicalAttributesOn: aWriter [
	| sortedAttributeNames |

	sortedAttributeNames :=
		self keys sort: [:a :b |
			| prefixOfA prefixOfB namespaceURIOfA namespaceURIOfB |
			"the namespace URI is the primary key and
			the local name is the secondary key"
			prefixOfA := a xmlWriterPrefixBeforeLocalName.
			prefixOfB := b xmlWriterPrefixBeforeLocalName.
			namespaceURIOfA := aWriter resolveAttributePrefix: prefixOfA.
			namespaceURIOfB := aWriter resolveAttributePrefix: prefixOfB.
			namespaceURIOfA < namespaceURIOfB
				or: [namespaceURIOfA = namespaceURIOfB
					and: [
						(a xmlWriterLocalNameAfterPrefix: prefixOfA)
							<= (b xmlWriterLocalNameAfterPrefix: prefixOfB)]]].

	"use to:do: for fast writing"
	1 to: sortedAttributeNames size do: [:i | | attributeName |
		attributeName := sortedAttributeNames at: i.
		aWriter
			writeAttributeName: attributeName
			value: (self at: attributeName)].
]
