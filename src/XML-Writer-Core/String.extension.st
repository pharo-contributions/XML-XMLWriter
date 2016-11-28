Extension { #name : #String }

{ #category : #'*XML-Writer-Core' }
String >> embedInXMLMarkupWriter: aMarkupWriter [
	aMarkupWriter writer string: self
]

{ #category : #'*XML-Writer-Core' }
String >> xmlWriterLocalNameAfterPrefix: aPrefix [
	"optimized"
	| prefixSize |

	(prefixSize := aPrefix size) > 0
		ifTrue: [^ self copyFrom: prefixSize + 2 to: self size]
		ifFalse: [^ self]
]

{ #category : #'*XML-Writer-Core' }
String >> xmlWriterPrefixBeforeLocalName [
	"optimized"
	| i |

	i := self size.
	[i > 1]
		whileTrue: [
			((self at: i) == $:)
				ifTrue: [^ (self copyFrom: 1 to: i - 1)].
			i := i - 1].
	^ ''.
]
