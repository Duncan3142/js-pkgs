fn ext { | @xargs |
	var cmd = $xargs[0]
	var args = $xargs[1..]
	(external $cmd) $@args
}

fn quiet { | @xargs |
	ext $@xargs 2> /dev/null | only-values
}
