# frozen_string_literal: true

module Decidim
  module SocioDemographicAuthorizationHandler
    module ApplicationHelper
      def participatory_processes_select_field(form, name, options = {})
        label = I18n.t(name.to_s, scope: "decidim.authorization_handlers.socio_demographic_authorization_handler.fields")
        options = options.reverse_merge(
          include_blank: I18n.t("blank_option", scope: "decidim.verifications.participatory_process"),
          label:
        )

        form.select(
          name,
          participatory_processes_options,
          options,
          { name: "#{form.object_name}[#{name}", id: "#{name}-select" }
        )
      end

      def participatory_processes_options
        participatory_spaces = fetch_participatory_spaces

        options = participatory_spaces.group_by { |item| item.manifest.name }.flat_map do |manifest_name, items|
          grouped_options(manifest_name, items)
        end

        safe_join(options)
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

      private

      def fetch_participatory_spaces
        Decidim::ParticipatoryProcess.where(organization: current_organization).published.to_a +
          Decidim::Assemblies::OrganizationPublishedAssemblies.new(current_organization).query.to_a
      end

      def grouped_options(manifest_name, collection)
        return [] if collection.empty?

        options = []
        translated_manifest_name = I18n.t("decidim.manifest.#{manifest_name}", default: manifest_name.to_s.humanize)

        options << disabled_header_option(translated_manifest_name)
        collection.each do |item|
          options << content_tag(:option, translated_attribute(item.title), value: "#{manifest_name.to_s.singularize}_id_#{item.id}")
        end

        options
      end

      def disabled_header_option(name)
        content_tag(:option, name, disabled: true)
      end
    end
  end
end
