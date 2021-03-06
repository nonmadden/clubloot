class AnnouncementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_announcement, only: :update

  def index
    @announcements = Announcement.active
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(announcement_params)

    respond_to do |format|
      # if @announcement.save
      #   format.html { redirect_to @announcement, notice: 'Announcement was successfully created.' }
      #   format.json { render :show, status: :created, location: @announcement }
      # else
      #   format.html { render :new }
      #   format.json { render json: @announcement.errors, status: :unprocessable_entity }
      # end
      @announcement.save
      format.html { redirect_to announcements_path, notice: 'Announcement was successfully created.' }
      format.json { render :show, status: :created, location: @announcement }
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to announcements_path, notice: 'Announcement was successfully updated.' }
      #   format.html { redirect_to @announcement, notice: 'Announcement was successfully updated.' }
      #   format.json { render :show, status: :ok, location: @announcement }
      # else
      #   format.html { render :edit }
      #   format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.update(active: false)
    User.all.each do |user|
      user.announcements.delete(@announcement)
    end
    respond_to do |format|
        format.html { redirect_to announcements_path, notice: 'Announcement was successfully updated.' }
    #   format.html { redirect_to announcements_url, notice: 'Announcement was successfully destroyed.' }
    #   format.json { head :no_content }
    end
  end

  private
   def set_announcement
      @announcement = Announcement.find(params[:id])
    end

   def announcement_params
      params.require(:announcement).permit(:publish, :description)
    end
end
