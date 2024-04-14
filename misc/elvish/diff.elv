use ./ext

fn same { |l r|
	try {
		ext:quiet diff $l $r
		put $true
	} catch err {
		var code = $err[reason][exit-status]
		if (eq $code 1) {
			put $false
		} else {
			fail $err
		}
	}
}
