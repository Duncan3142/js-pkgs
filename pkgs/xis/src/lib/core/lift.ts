import type { ExIn, ExIssues, ExOut, ExArgs, ExCtx } from "#core/kernel.js"
import { XisAsync, type ExecResultAsync } from "#core/async.js"
import type { XisSyncBase } from "./sync.js"
import type { Effect } from "./book-keeping.js"

export interface XisLiftProps<X extends XisSyncBase> {
	inner: X
}

export interface XisLiftArgs<X extends XisSyncBase> {
	props: XisLiftProps<X>
}

export class XisLift<X extends XisSyncBase> extends XisAsync<
	ExIn<X>,
	ExIssues<X>,
	ExOut<X>,
	ExCtx<ExIn<X>>
> {
	#props: XisLiftProps<X>
	get inner(): X {
		return this.#props.inner
	}
	get effect(): Effect {
		return this.inner.effect
	}
	constructor(args: XisLiftArgs<X>) {
		super()
		this.#props = args.props
	}
	exec(args: ExArgs<X>): ExecResultAsync<ExIssues<X>, ExOut<X>> {
		return Promise.resolve(this.inner.exec(args))
	}
}

export const lift = <X extends XisSyncBase>(inner: X): XisLift<X> =>
	new XisLift({ props: { inner } })
