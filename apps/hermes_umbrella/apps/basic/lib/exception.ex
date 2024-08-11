defmodule Basic.Exception do
  @enforce_keys [:code]
  defexception [:message, :code]
end
