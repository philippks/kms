FactoryBot.define do
  factory :text_template, class: TextTemplate do
    text { 'Dies ist eine Text Vorlage' }
    activity_category
  end
end
