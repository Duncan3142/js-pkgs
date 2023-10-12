export default `{
	"name": "@duncan3142/{{ dashCase name }}",
	"repository": "https://github.com/duncan3142/js-pkgs",
	"publishConfig": {
		"registry": "https://npm.pkg.github.com",
		"access": "restricted"
	},
	"description": "{{ description }}",
	"keywords": [],
	"version": "0.0.0",
	"author": "Duncan Giles",
	"type": "module",
	"license": "MIT",
	"engines": {
		"node": ">=18",
		"pnpm": ">=8"
	},
	"imports": {
		"#lib/*.js": {
			"import": "./.tsc/dist/lib/*.js"
		}
	},
	"exports": {
		"./*": {
			"types": "./.tsc/dist/lib/*.d.ts",
			"import": "./.tsc/dist/lib/*.js"
		}
	},
	"files": [
		".tsc/dist/**/*.js",
		".tsc/dist/**/*.ts",
		".tsc/dist/**/*.map"
	],
	"scripts": {
		"clean": "rm -rf .eslint .prettier .tsc .coverage .package",
		"format": "prettier --check --cache --cache-location='.prettier/cache' --cache-strategy content .",
		"format:fix": "prettier --write --cache --cache-location='.prettier/cache' --cache-strategy content .",
		"assets": "tsc --build",
		"assets:watch": "tsc --build --watch",
		"test:eslint": "eslint --max-warnings 0 --cache --cache-location '.eslint/cache' --cache-strategy content .",
		"test:eslint:fix": "eslint --fix --max-warnings 0 --cache --cache-location '.eslint/cache' --cache-strategy content .",
		"test:node": "node --test .tsc/test/"
	},
	"peerDependencies": {},
	"dependencies": {},
	"devDependencies": {
		"prettier": "^3.0.3",
		"@duncan3142/prettier-config": "^0.1.0",
		"@duncan3142/tsc-config": "^0.1.0",
		"@duncan3142/eslint-config": "^0.1.0",
		"@types/eslint": "^8.44.0",
		"@typescript-eslint/eslint-plugin": "^6.0.0",
		"@typescript-eslint/parser": "^6.0.0",
		"eslint": "^8.44.0",
		"eslint-import-resolver-typescript": "^3.5.5",
		"eslint-plugin-eslint-comments": "^3.2.0",
		"eslint-plugin-import": "^2.27.5",
		"eslint-plugin-promise": "^6.1.1",
		"@types/node": "^18.17.1",
		"typescript": "^5.1.6"
	}
}
`
