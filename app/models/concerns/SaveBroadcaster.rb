module SaveBroadcaster
  extend ActiveSupport::Concern

  included do
    after_create_commit :broadcast_created
    after_update_commit :broadcast_updated
    after_validation :broadcast_validation_failed, if: :errors_present?
  end

  private

  def object_name
    self.class.table_name.singularize
  end

  def broadcast_created
    key = "created_#{object_name}".to_sym
    broadcast(key, self)
  end

  def broadcast_updated
    key = "updated_#{object_name}".to_sym
    broadcast(key, self)
  end

  def broadcast_validation_failed
    key = "failed_#{object_name}".to_sym
    broadcast(key, self)
  end

  def errors_present?
    self.errors.present?
  end
end