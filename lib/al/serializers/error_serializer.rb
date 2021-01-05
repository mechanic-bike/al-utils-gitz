class ErrorSerializer < ActiveModel::Serializer

  attributes :errors, :sentence

  def errors
    errors = []
    object.errors.each do |id, title|
      errors << { id: id, title: object.errors.full_message(id, title), status: @instance_options[:status] }
    end
    errors
  end

  def sentence
    object.errors.full_messages.to_sentence
  end

end
