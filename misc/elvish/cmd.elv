use ./ext

fn has { |cmd|
	try {
		ext:quiet which $cmd
		put $true
	} catch {
		put $false
	}
}
