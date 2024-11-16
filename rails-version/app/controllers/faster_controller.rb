class FasterController < ApplicationController
  def index
    @pokemon_pair = load_from_json
    @next_pair = Pokemon.unscoped.random_pair.load_async
  end

  def create
    Vote.create(winner_id: params[:winner_id], loser_id: params[:loser_id])

    @next_pair = Pokemon.unscoped.random_pair.load_async
    @pokemon_pair = load_from_json(params[:next_pair])
    cookies[:current_pair] = @pokemon_pair.to_json

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  private

  def load_from_json(cookie_val = cookies['current_pair'])
    if (val = cookie_val).present?
      JSON.parse(val).map { Pokemon.new(_1) }
    else
      Pokemon.random_pair.unscoped.load_async
    end
  end
end
