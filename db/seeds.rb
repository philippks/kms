employee = Employee.create!(
  {name: "Friedrich Schiller", initials: "FS", hourly_rate: 150, worktime_model: 0}
)
CustomerGroup.create!([
  {id: 2, name: "BNI", not_chargeable: false},
  {id: 3, name: "Administration", not_chargeable: true}
])
customers = Customer.create!([
  {name: "Peter Meier", address: "", customer_group_id: nil},
  {name: "Fritz Kalkbrenner", address: "", customer_group_id: 2},
  {name: "Steuern", address: "", customer_group_id: 3}
])
Absence.create!([
  {employee: employee, from_date: "2015-02-25", to_date: "2015-02-25", hours: 3.0, reason: 1, text: "Kurz beim Arzt"},
  {employee: employee, from_date: "2015-02-02", to_date: "2015-02-08", hours: nil, reason: 0, text: "Meine Ferien"}
])
Activity.create!([
  {text: "Meine erste Leistung", note: "", employee: employee, customer: customers.first, activity_category_id: nil, hours: 2.5, hourly_rate: 150, date: "2015-02-25"},
  {text: "Meine zweite Leistung", note: "", employee: employee, customer: customers.first, activity_category_id: nil, hours: 1.5, hourly_rate: 150, date: "2015-02-25"},
  {text: "Kleiner Aufwand", note: "", employee: employee, customer: customers.first, activity_category_id: nil, hours: 0.5, hourly_rate: 100, date: "2015-02-18"}
])
ActivityCategory.create!([
  {id: 1, name: "Steuern"},
  {id: 2, name: "Buchhaltung"}
])
TextTemplate.create!([
  {text: "Textvorlage für Steuern", activity_category_id: 1},
  {text: "Textvorlage für Buchhaltung", activity_category_id: 2}
])
TargetHours.create!([
  {date: "2015-02-19 00:00:00", hours: 0},
  {date: "2015-01-19 00:00:00", hours: 0},
  {date: "2014-12-30 00:00:00", hours: 0}
])
