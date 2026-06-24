class Story < ApplicationRecord
  # Status: pending, generating, completed, failed
  
  def append_content!(new_text)
    self.update_column(:content, "#{self.content}#{new_text}")
  end
end
