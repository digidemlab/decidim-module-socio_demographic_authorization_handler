# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module SocioDemographicAuthorizationHandler
    module ProposalSerializerExtensions
      extend ActiveSupport::Concern

      included do
        def author_fields
          is_author_user_group = resource.coauthorships.map(&:decidim_user_group_id).any?

          {
            id: resource.authors.map(&:id),
            name: resource.authors.map do |author|
              author_name(is_author_user_group ? resource.coauthorships.first.user_group : author)
            end,
            url: resource.authors.map do |author|
              author_url(is_author_user_group ? resource.coauthorships.first.user_group : author)
            end,
            email: resource.authors.map do |author|
              author.email
            end,
            phone: resource.authors.map do |author|
              authorization = Decidim::Authorization.find_by(decidim_user_id: author.id)
              authorization.nil? ? "" : authorization.metadata["phone_number"]
            end
          }
        end
      end
    end
  end
end
