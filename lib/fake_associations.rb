require "fake_associations/version"

module FakeAssociations
  extend ActiveSupport::Concern
  DEFINED_METHODS = {}

  module ClassMethods
    def has_many(target_name, options = {})
      DEFINED_METHODS[target_name] = { options: options }

      base_class_name = self.name
      target_class_name = target_name.to_s.chomp.classify
      target_column_name = options[:foreign_key] || "#{self.name.downcase}_id"

      if options[:through].present?
        through_class_name = options[:through].to_s.classify
        target_column_name = :id

        select_through_column_name = :id

        if options[:source].present?
          target_class_name = options[:source].to_s.classify
          select_through_column_name = "#{options[:source]}_id".to_sym

          through_class_name = DEFINED_METHODS[
            options[:through]][:options][:class_name] || through_class_name

          through_reflection =
            through_class_name.constantize.reflect_on_association(
              options[:source])
            target_class_name = through_reflection.options[:class_name] if through_reflection.options[:class_name].present?
        end
      end

      target_class_name = options[:class_name] if options[:class_name]

      define_method(target_name) do
        if options[:through].present?
          through_records = send(options[:through])
          targets = through_records.select(select_through_column_name)
        end

        targets ||= [self.id]
        if target_class_name == base_class_name
          targets.map do |target|
            id = target.send(select_through_column_name)
            base_class_name.constantize.new(id: id)
          end
        else
          target_class_name.constantize.where(
            "#{target_column_name}": targets)
        end
      end
    end
  end
end
