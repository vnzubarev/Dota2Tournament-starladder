# frozen_string_literal: true

class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[register_team withdraw_team]
  before_action :set_team,       only: %i[register_team withdraw_team]
  before_action :check_user,     only: %i[register_team withdraw_team]

  def index
    @tournaments = Tournament.all
  end

  def register_team
    @tournament.teams << @team

    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Successfully registered' }
    end
  end

  def withdraw_team
    @tournament.teams.destroy(@team)

    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Successfully withdrawn' }
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def check_user
    unless current_user_owns_team?(@team)
      redirect_to tournaments_path, notice: 'You have no permission for this action!'
    end
  end

  def tournament_params
    params.fetch(:tournament, {})
  end
end
