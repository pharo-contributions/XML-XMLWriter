Extension { #name : #Character }

{ #category : #'*XML-Writer-Core' }
Character >> embedInMarkupWriter: aMarkupWriter [
	self asString embedInMarkupWriter: aMarkupWriter
]
