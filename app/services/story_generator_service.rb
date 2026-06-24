# app/services/story_generator_service.rb
class StoryGeneratorService
  def initialize(story_id)
    @story = Story.find(story_id)
    @client = RubyLLM::Client.new(api_key: Rails.application.credentials.llm_api_key)
  end

  def call
    @story.update(status: "generating", content: "")

    prompt = <<~PROMPT
      Tulis dongeng anak tentang #{@story.character} di #{@story.setting}.
      Pesan moral: #{@story.moral_lesson}. 
      Bahasa: Indonesia ceria, ramah anak. Maksimal 200 kata.
    PROMPT

    @client.chat(
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: prompt }],
      stream: true
    ) do |chunk|
      content = chunk.dig(:choices, 0, :delta, :content)
      next if content.blank?

      @story.append_content!(content)
      @story.broadcast_append_to(
        @story,
        target: "story_content_#{@story.id}",
        html: content
      )
    end

    @story.update(status: "completed")
  rescue => e
    @story.update(status: "failed")
    Rails.logger.error "AI Story Error: #{e.message}"
  end
end