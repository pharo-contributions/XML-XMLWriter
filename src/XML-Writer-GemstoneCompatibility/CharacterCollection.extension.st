Extension { #name : #CharacterCollection }

{ #category : #'*XML-Writer-GemstoneCompatibility' }
CharacterCollection >> embedInXMLMarkupWriter: aMarkupWriter [
	aMarkupWriter writer string: self
]
