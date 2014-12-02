Extension { #name : #String }

{ #category : #'*XML-Writer-Core' }
String >> embedInMarkupWriter: aMarkupWriter [
	aMarkupWriter writer string: self
]
