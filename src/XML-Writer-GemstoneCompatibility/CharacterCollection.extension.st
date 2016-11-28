Extension { #name : #CharacterCollection }

{ #category : #'*XML-Writer-GemstoneCompatibility' }
CharacterCollection >> embedInXMLMarkupWriter: aMarkupWriter [
	aMarkupWriter writer string: self
]

{ #category : #'*XML-Writer-GemstoneCompatibility' }
CharacterCollection >> xmlWriterLocalNameAfterPrefix: aPrefix [
	"optimized"
	| prefixSize |

	(prefixSize := aPrefix size) > 0
		ifTrue: [^ self copyFrom: prefixSize + 2 to: self size]
		ifFalse: [^ self]
]

{ #category : #'*XML-Writer-GemstoneCompatibility' }
CharacterCollection >> xmlWriterPrefixBeforeLocalName [
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
