fn status { |err|
	var reason = $err[reason]
	if (has-key $reason exit-status) {
		put $reason[exit-status]
	} else {
		fail $err
	}
}

fn catch-status { | cmd &codes=[1] catch |
	try {
		$cmd
	} catch err {
		var code = ( status $err )
		if (has-value $codes $code) {
			$catch
		} else {
			fail $err
		}
	}
}
