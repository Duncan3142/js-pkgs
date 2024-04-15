use ./ext
use ./quiet
use ./err

fn same { |l r|
	err:catch-status {
		quiet:only-v { ext:ex diff $l $r }
		put $true
	} { put $false }
}
