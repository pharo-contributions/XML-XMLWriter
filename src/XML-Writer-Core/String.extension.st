Extension { #name : #String }

{ #category : #'*XML-Writer-Core' }
String >> embedInXMLMarkupWriter: aMarkupWriter [
	aMarkupWriter writer string: self
]
