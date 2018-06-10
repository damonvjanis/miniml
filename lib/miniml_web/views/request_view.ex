defmodule MinimlWeb.RequestView do
  use MinimlWeb, :view
  use JaSerializer.PhoenixView
  
  attributes [:full, :minified, :inserted_at, :updated_at]
  
end
