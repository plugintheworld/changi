module Changi
  module Reader
    class CategoryReader < StringReader
      def read attribute, owner
        fail 'CategoryReader can only be used for Entry attributes.' unless owner.is_a? Entry

        cli.say "#{attribute[:name].capitalize}:\n"
        cli.choose do |menu|
          menu.choices *categories(owner.entry_set)
          menu.choice 'Other (create new)' do
            cli.ask "Please insert #{attribute[:name]}:"
          end
          menu.choice('Abort') { exit }
        end
      end

      private

      def categories entry_set
        (entry_set.previous_categories + entry_set.config.default_categories).uniq
      end
    end
  end
end
