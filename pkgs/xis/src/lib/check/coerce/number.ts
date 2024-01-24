import { type ExecResultSync, XisSync } from "#core/sync.js"
import { trueTypeOf } from "#util/base-type.js"
import { Right } from "purify-ts/Either"

import {
	coerceIssue,
	XIS_COERCE,
	type CoerceIssue,
	type XisCoerceMessages,
	type XisCoerceArgs,
} from "./core.js"
import type { XisExecArgs } from "#core/args.js"

export class XisCoerceNumber extends XisSync<unknown, CoerceIssue, number> {
	#messages: XisCoerceMessages
	constructor(args: XisCoerceArgs) {
		super()
		this.#messages = args.messages ?? {
			XIS_COERCE,
		}
	}
	exec(args: XisExecArgs): ExecResultSync<CoerceIssue, number> {
		const { value, locale, path } = args
		const valueType = trueTypeOf(value)
		const num = valueType === "symbol" ? NaN : Number(value)

		if (Number.isFinite(num)) {
			return Right(num)
		}

		const message = this.#messages.XIS_COERCE({
			value,
			path,
			locale,
			ctx: null,
			props: {
				desired: "number",
				type: valueType,
			},
		})
		return coerceIssue({ desired: "number", received: value, type: valueType, path, message })
	}
}

export const number = (args: XisCoerceArgs) => new XisCoerceNumber(args)
