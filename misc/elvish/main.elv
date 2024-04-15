#!/usr/bin/env elvish

use str

use ./cmd
use ./ext
use ./quiet
use ./diff

var title = 'Hello Elves!'

echo $title

echo A
ext:ex git status
echo B
quiet:silent { ext:ex git status }

fn printHas { |name|
	if ( cmd:has $name ) {
		echo $name' is installed'
	} else {
		echo $name' is not installed'
	}
}

printHas elvish
printHas fish

var lines = [ ( cat './lines.txt' | from-lines ) ]

echo lines (count $lines) $lines

var upperLines = [ ( each { |x| str:to-upper $x } $lines ) ]

echo upperLines (count $upperLines) $upperLines

var linesCopy = []

for x $lines {
	set linesCopy = [$@linesCopy $x]
}

echo linesCopy (count $linesCopy) $linesCopy

echo A
diff:same lines.txt lines.txt
echo B
diff:same lines.txt data.json
echo C
try {
	diff:same alpha beta
} catch err {
	show $err
	put $err
}

echo done
