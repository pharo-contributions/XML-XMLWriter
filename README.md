# XML-XMLWriter

[![Build Status](https://travis-ci.org/pharo-contributions/XML-XMLWriter.svg?branch=master)](https://travis-ci.org/pharo-contributions/XML-XMLWriter) [![Coverage Status](https://coveralls.io/repos/github/pharo-contributions/XML-XMLWriter/badge.svg?branch=master)](https://coveralls.io/github/pharo-contributions/XML-XMLWriter?branch=master)

This package provides a Seaside-like, block-based API for XML generation for [Pharo](http://www.pharo.org)

## Installation

```smalltalk
Metacello new
	baseline: 'XMLWriter';
	repository: 'github://pharo-contributions/XML-XMLWriter/src';
	load.
```
## Usage

A simple example on how to use the XML writer

```Smalltalk
|writer|
writer := XMLWriter new.
writer 
	enablePrettyPrinting;
	comment: 'A simple XML structure';
	tag: 'hello'
	with: [ writer tag: 'world' ].
writer asString
```

results in the following XML output
```XML
<!--A simple XML structure-->
<hello>
    <world/>
</hello>
```

Check the class **XMLWriterTest** for many other examples.

## LICENSE
[MIT License](LICENSE)

## History
This project was migrated from [http://smalltalkhub.com/#!/~PharoExtras/XMLWriter](http://smalltalkhub.com/#!/~PharoExtras/XMLWriter)
