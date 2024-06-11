defmodule MyException do
  @enforce_keys [:code]
  defexception [:message, :code]
end
