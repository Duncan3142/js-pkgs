use ./ext
use ./quiet

fn has { |cmd|
	try {
		quiet:silent { ext:ext which $cmd }
		put $true
	} catch {
		put $false
	}
}
