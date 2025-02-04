# frozen_string_literal: true

module Decidim
  module SocioDemographicAuthorizationHandler
    # Custom helpers, scoped to the socio_demographic_authorization_handler engine.
    module ApplicationHelper
      def participatory_spaces_select_field(form, name, options = {})
        label = I18n.t(name.to_s, scope: "decidim.authorization_handlers.socio_demographic_authorization_handler.fields")
        options = options.reverse_merge(
          include_blank: I18n.t("blank_option", scope: "decidim.verifications.participatory_process"),
          label:
        )

        form.select(
          name,
          grouped_options_for_select(participatory_spaces_options(form.object.participatory_spaces)),
          options,
          { name: "#{form.object_name}[#{name}", id: "#{name}-select" }
        )
      end

      def participatory_spaces_options(participatory_spaces)
        participatory_spaces.group_by { |item| item.manifest.name }.map do |manifest_name, items|
          [
            I18n.t("decidim.admin.titles.#{manifest_name}", default: manifest_name.to_s.humanize),
            items.map { |item| [translated_attribute(item.title), item.to_global_id.to_s] }
          ]
        end
      end

      def genders
        StaticAuthorizationData.genders
      end

      def ages
        StaticAuthorizationData.ages
      end

      def zones
        StaticAuthorizationData.zones
      end
    end
  end
end
