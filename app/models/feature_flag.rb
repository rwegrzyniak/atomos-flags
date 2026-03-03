# frozen_string_literal: true

class FeatureFlag < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  
  scope :active, -> { where(active: true) }

  def active?
    active == true
  end

  # Helper for manual testing or console
  def enable!
    update!(active: true)
  end

  def disable!
    update!(active: false)
  end
end
