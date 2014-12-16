Extension { #name : #CharacterCollection }

{ #category : #'*XML-Writer-GemstoneCompatibility' }
CharacterCollection >> embedInMarkupWriter: aMarkupWriter [
	aMarkupWriter writer string: self
]
