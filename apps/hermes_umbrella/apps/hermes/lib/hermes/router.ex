defprotocol Hermes.Router do
  def route(self, bucket, mod, fun, args)
end
