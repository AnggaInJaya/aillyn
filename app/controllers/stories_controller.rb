class StoriesController < ApplicationController
  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    if @story.save
      GenerateStoryJob.perform_later(@story.id)
      redirect_to story_path(@story)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @story = Story.find(params[:id])
  end

  private

  def story_params
    params.require(:story).permit(:character, :setting, :moral_lesson)
  end
end
