defmodule Miniml.Requests.Random do
  @moduledoc false

  def generate() do
    alphabet = String.split("abcdefghijklmnopqrstuvwxyz", "")
    upcase = Enum.map(alphabet, fn l -> String.upcase(l) end)
    numbers = String.split("0123456789", "")

    list = alphabet ++ upcase ++ numbers
    list = Enum.filter(list, &(&1 != ""))

    random_six =
      for _ <- 1..6 do
        Enum.random(list)
      end

    Enum.join(random_six)
  end
end
