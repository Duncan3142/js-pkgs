fn only-values { | f |
	{ $f 2> /dev/null } # | only-values
}

fn only-bytes { | f |
	{ $f 2> /dev/null } | only-bytes
}

fn all { | f |
	$f 1> /dev/null 2> &1
}
