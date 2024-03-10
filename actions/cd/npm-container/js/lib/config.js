import {argv, env} from "node:process"

const args = argv.slice(2)

export const environment = ({parseLogEnv}) => {
	return {
		env:{
			log: parseLogEnv(env)
		},
		raw: {env, argv},
		args
	}
}
