use ./ext
use ./quiet

fn has { |cmd|
	try {
		quiet:all { ext:ext which $cmd }
		put $true
	} catch {
		put $false
	}
}
