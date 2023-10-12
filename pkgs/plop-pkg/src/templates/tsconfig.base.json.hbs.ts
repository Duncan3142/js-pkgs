export default `{
	"$schema": "https://json.schemastore.org/tsconfig",
	"extends": "@duncan3142/tsc-config/tsconfig.json",
	"compilerOptions": {
		"noEmit": false,
		"paths": {
			"#lib/*": ["./src/lib/*"]
		}
	},
	"include": []
}
`
