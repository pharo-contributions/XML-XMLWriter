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
			| aLocalName bLocalName aNamespaceURI bNamespaceURI |
			"the namespace URI is the primary key and
			the local name is the secondary key"
			aLocalName := a xmlLocalNameAfterPrefix.
			bLocalName := b xmlLocalNameAfterPrefix.
			aNamespaceURI :=
				aWriter resolveAttributePrefix:
					(a xmlPrefixBeforeLocalName: aLocalName).
			bNamespaceURI :=
				aWriter resolveAttributePrefix:
					(b xmlPrefixBeforeLocalName: bLocalName).
			aNamespaceURI < bNamespaceURI
				or: [aNamespaceURI = bNamespaceURI
					and: [aLocalName <= bLocalName]]].

	"use to:do: for fast writing"
	1 to: sortedAttributeNames size do: [:i | | attributeName |
		attributeName := sortedAttributeNames at: i.
		aWriter
			writeAttributeName: attributeName
			value: (self at: attributeName)].
]
