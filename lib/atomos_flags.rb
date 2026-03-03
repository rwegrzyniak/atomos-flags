# frozen_string_literal: true

require "atomos_flags/version"
require "atomos_flags/engine"
require "digest/md5"

module AtomosFlags
  # Thread-safe storage for flag decisions within a single execution flow (e.g. request)
  class Current < ActiveSupport::CurrentAttributes
    attribute :decisions
  end

  # Main entry point for feature flag checks.
  def self.on?(slug, actor: nil)
    slug = slug.to_s
    Current.decisions ||= {}
    
    # Return memoized decision for this request/flow
    cache_key = actor ? "#{slug}:#{actor.class.name}:#{actor.id}" : slug
    return Current.decisions[cache_key] if Current.decisions.key?(cache_key)

    flag = fetch_flag(slug)
    decision = if flag&.active?
                 evaluate_rules(flag.rules, actor)
               else
                 false
               end

    Current.decisions[cache_key] = decision
  end

  # Returns a hash of all active flags for an actor, 
  # perfect for snapshotting into an Atom.
  def self.snapshot(actor)
    FeatureFlag.active.each_with_object({}) do |flag, hash|
      hash[flag.slug] = on?(flag.slug, actor: actor)
    end
  end

  private

  def self.fetch_flag(slug)
    FeatureFlag.find_by(slug: slug)
  end

  def self.evaluate_rules(rules, actor)
    return true if rules.blank? # Global toggle if active but no rules

    # 1. Target by Context IDs
    if rules["context_ids"].present? && actor.respond_to?(:context_id)
      return true if rules["context_ids"].include?(actor.context_id)
    end

    # 2. Target by User Email
    if rules["user_emails"].present? && actor.respond_to?(:email_address)
      return true if rules["user_emails"].any? { |e| actor.email_address.include?(e) }
    end

    # 3. Target by Percentage (deterministic & stateless)
    if rules["percentage"].present? && actor.present?
      # Seed ensures the same actor always gets the same result for this flag
      id_seed = "#{actor.class.name}-#{actor.id}-#{rules['seed'] || 'default'}"
      return (Digest::MD5.hexdigest(id_seed).to_i(16) % 100) < rules["percentage"].to_i
    end

    false
  end
end
