module Activities
  class SuggestionsBuilder
    SUGGESTIONS_SIZE_LIMIT = 10

    def initialize(query:, customer_id: nil, activity_category_id: nil)
      @query = query
      @customer_id = customer_id
      @activity_category_id = activity_category_id
    end

    def build
      suggestions = {}
      suggestions[:for_activity_category] = suggestions_for_activity_category
      suggestions[:for_customer] = activities_suggestions_for_customer
      suggestions
    end

    private

    def suggestions_for_activity_category
      return [] if @activity_category_id.blank?

      activity_category.text_templates
                       .where('lower(text) LIKE lower(?)', "%#{@query}%")
                       .first(SUGGESTIONS_SIZE_LIMIT)
                       .pluck(:text)
    end

    def activities_suggestions_for_customer
      return [] if @customer_id.blank?

      Activity.for_customer(@customer_id).reorder(date: :desc)
              .where('lower(text) LIKE lower(?)', "%#{@query}%")
              .limit(SUGGESTIONS_SIZE_LIMIT)
              .pluck(:text)
              .uniq
    end

    def activity_category
      ActivityCategory.find @activity_category_id
    end
  end
end
