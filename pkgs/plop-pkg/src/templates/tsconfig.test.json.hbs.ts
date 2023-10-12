export default `{
	"$schema": "https://json.schemastore.org/tsconfig",
	"extends": "./tsconfig.base.json",
	"compilerOptions": {
		"emitDeclarationOnly": false,
		"rootDir": "test",
		"outDir": ".tsc/test",
		"tsBuildInfoFile": ".tsc/test/tsconfig.test.tsbuildinfo"
	},
	"references": [{ "path": "./tsconfig.build.json" }],
	"include": ["test/**/*"]
}
`
