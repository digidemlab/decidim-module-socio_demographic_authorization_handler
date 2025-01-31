# frozen_string_literal: true

module Decidim
  module SocioDemographicAuthorizationHandler
    class StaticAuthorizationData
      CONFIG_PATH = File.join(Decidim::SocioDemographicAuthorizationHandler::Engine.root, "config/authorization_handler.yml")

      def self.load_config
        YAML.load_file(CONFIG_PATH)["authorization_handler"]
      rescue StandardError
        { "genders" => [], "ages" => [], "zones" => [] }
      end

      def self.genders
        load_config["genders"]
      end

      def self.ages
        load_config["ages"]
      end

      def self.zones
        load_config["zones"]
      end
    end
  end
end
