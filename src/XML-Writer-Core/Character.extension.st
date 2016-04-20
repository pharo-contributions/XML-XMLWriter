Extension { #name : #Character }

{ #category : #'*XML-Writer-Core' }
Character >> embedInXMLMarkupWriter: aMarkupWriter [
	self asString embedInXMLMarkupWriter: aMarkupWriter
]
