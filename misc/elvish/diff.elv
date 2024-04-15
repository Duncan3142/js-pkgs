use ./ext
use ./quiet

fn same { |l r|
	try {
		quiet:only-values { ext:ex diff $l $r }
		put $true
	} catch err {
		var code = $err[reason][exit-status]
		if (eq $code 1) {
			put $false
		} else {
			put $err
			fail $err
		}
	}
}
