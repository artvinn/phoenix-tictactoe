defmodule InterfaceWeb.Presence do
  use Phoenix.Presence,
    otp_app: :tic_tac_toe,
    pubsub_server: Interface.PubSub

  # def handle_diff(diff, state) do
  # end
end
