Extension { #name : #BlockClosure }

{ #category : #'*XML-Writer-Core' }
BlockClosure >> embedInMarkupWriter: aMarkupWriter [
	self cull: aMarkupWriter writer
]
