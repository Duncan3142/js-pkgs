fn only-v { | f |
	{ $f 2> /dev/null } | only-values
}

fn only-b { | f |
	{ $f 2> /dev/null } | only-bytes
}

fn silent { | f |
	$f 1> /dev/null 2> &1
}
