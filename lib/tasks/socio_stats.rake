# frozen_string_literal: true

namespace :decidim do
  namespace :socio_stats do
    desc "Extract stats from authorizations"
    task :csv, [:organization_id] => :environment do |_task, args|
      organization_id = args.organization_id
      organization = Decidim::Organization.find(organization_id)
      abort("No organization found with ID #{organization_id}") unless organization

      authorizations = Decidim::Authorization.where(user: organization.users)

      CSV($stdout) do |csv|
        csv << ["Participatory Space", "Gender", "Age", "Living Area", "Count"]
        grouped_authorizations = authorizations.group_by do |authorization|
          [
            authorization.metadata["participatory_space"],
            authorization.metadata["gender"],
            authorization.metadata["age"],
            authorization.metadata["living_area"]
          ]
        end

        grouped_authorizations.each do |(participatory_space, gender, age, living_area), group|
          csv << [participatory_space, gender, age, living_area, group.size]
        end
      end
    end
  end
end
