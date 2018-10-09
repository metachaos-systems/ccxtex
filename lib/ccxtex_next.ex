defmodule Ccxtex.Next do
  
  @spec exchanges() :: [String.t]
  def exchanges() do
    js_fn = {"main.js", :exchanges}

    with {:ok, exchanges} <- NodeJS.call(js_fn, []) do
      {:ok, exchanges}
    else
      err_tup -> err_tup
    end
  end

end
