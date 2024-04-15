use ./ext
use ./quiet

fn same { |l r|
	try {
		quiet:only-v { ext:ex diff $l $r }
		put $true
	} catch err {
		var reason = $err[reason]
		var code = (num -1)
		if (has-key $reason exit-status) {
			set code = $reason[exit-status]
		}
		if (== $code (num 1)) {
			put $false
		} else {
			show $err
			fail $err
		}
	}
}
