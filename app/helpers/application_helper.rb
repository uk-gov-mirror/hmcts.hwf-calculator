module ApplicationHelper
  # Renders a group of checkboxes following GDS guidelines with guidance text
  #
  # @param [ActionView::Helpers::FormBuilder] form
  # @param [Symbol] method The active model attribute to generate the multiple choices for
  # @param [Array<Array>] choices An array of arrays where the inner array contains the 'key', the
  #   'display text' and 'guidance id' (nil for none)
  #   guidance id will mean more to you if you are familiar with GDS multiple choices with guidance
  #
  # @return [String] The HTML to render
  def gds_multiple_choices_with_guidance(form:, method:, choices:)
    form.collection_check_boxes method, choices, :first, :second do |b|
      gds_checkbox_with_guidance(b)
    end
  end

  # Renders error messages for an attribute from a model or form object
  # based on active model, but renders them
  # GDS style (span with a class of 'error-message')
  # @param [ActiveModel::Model] model The model or form object to get the errors from
  # @param [Symbol] method The attribute that you want the error messages for
  def gds_error_messages(model:, method:)
    errors = model.errors
    return '' unless errors.include?(method)
    errors.full_messages_for(method).each do |error|
      concat content_tag('span', error, class: 'error-message')
    end
  end

  private

  def calculator_feedback_explanation(calculation)
    remaining_fields = calculation.required_fields_affecting_likelihood
    return [] if remaining_fields.empty?
    a = [I18n.t('calculation.feedback.explanation_suffix')]
    remaining = remaining_fields.map do |field|
      I18n.t("calculation.feedback.explanation_suffix_fields.#{field}")
    end
    add_explanation_suffix(a, remaining)
  end

  def add_explanation_suffix(phrases, remaining)
    if remaining.length == 1
      phrases << remaining.first
    else
      phrases << remaining[0..-2].join(', ')
      phrases << I18n.t('calculation.feedback.explanation_suffix_joining_word')
      phrases << remaining.last
    end
    phrases
  end

  def gds_checkbox_with_guidance(builder)
    guidance = builder.object.last
    guidance_id = "prefix_#{builder.object.first}"
    data_attrs = { target: guidance.present? ? guidance_id : nil }
    content = builder.check_box + builder.label
    if guidance.present?
      content << content_tag('div', guidance, class: 'panel panel-border-narrow js-hidden', id: guidance_id,
                                              data: { behavior: 'multiple_choice_guidance' })
    end
    content_tag('div', class: 'multiple-choice', data: data_attrs) { content }
  end
end
