# XML-XMLWriter

This package provides a [Seaside](http://www.seaside.st)-like, block-based API for XML generation for [Pharo](http://www.pharo.org)

[![Unit Tests](https://github.com/pharo-contributions/XML-XMLWriter/workflows/Unit%20Tests/badge.svg?branch=main)](https://github.com/pharo-contributions/XML-XMLWriter/actions?query=workflow%3AUnit%20Tests)
[![Coverage Status](https://codecov.io/github/pharo-contributions/XML-XMLWriter/coverage.svg?branch=main)](https://codecov.io/gh/pharo-contributions/XML-XMLWriter/branch/master)

[![Pharo 7](https://img.shields.io/badge/Pharo-7.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 8](https://img.shields.io/badge/Pharo-8.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 9](https://img.shields.io/badge/Pharo-9.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 10](https://img.shields.io/badge/Pharo-10-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)


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
