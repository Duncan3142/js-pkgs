/**
 * Never error
 * @param message - Error message
 */
const never = (message = "Unexpected default case"): never => {
	throw new Error(message)
}

export { never }
export default never
