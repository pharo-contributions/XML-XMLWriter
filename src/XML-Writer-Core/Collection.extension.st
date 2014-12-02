Extension { #name : #Collection }

{ #category : #'*XML-Writer-Core' }
Collection >> embedInMarkupWriter: aMarkupWriter [
	self do: [:each | each embedInMarkupWriter: aMarkupWriter]
]
