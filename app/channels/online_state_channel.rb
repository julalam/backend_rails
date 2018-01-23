class OnlineStateChannel < ApplicationCable::Channel
  def subscribed
      stream_from "online_state_#{params[:id]}"
  end
end
