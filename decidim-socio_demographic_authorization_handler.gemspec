# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/socio_demographic_authorization_handler/version"

Gem::Specification.new do |s|
  s.version = Decidim::SocioDemographicAuthorizationHandler::VERSION
  s.authors = ["Armand"]
  s.email = ["fardeauarmand@gmail.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/OpenSourcePolitics/decidim-module-socio_demographic_authorization_handler"
  s.required_ruby_version = ">= 3.1"

  s.name = "decidim-socio_demographic_authorization_handler"
  s.summary = "A decidim socio_demographic_authorization_handler module"
  s.description = "Description."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::SocioDemographicAuthorizationHandler::COMPAT_DECIDIM_VERSION
  s.metadata["rubygems_mfa_required"] = "true"
end
