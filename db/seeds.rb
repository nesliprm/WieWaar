# Sample data for development: the team and a day of calendar events.
# Run with: bin/rails db:seed (safe to run again)

names = %w[Willem-Jan Maarten Arthur Esther Barry Wouter James Nesli Joost Tobias Sam]

employees = names.to_h do |name|
  employee = Employee.find_or_create_by!(email: "#{name.downcase}@example.com") do |e|
    e.name = name
  end
  [ name, employee ]
end

# Today's events, in Dutch time (config.time_zone)
today = Time.zone.today
at = ->(hour, min = 0) { today.in_time_zone.change(hour: hour, min: min) }

events = [
  [ "Esther",  "thuis",     at.(8),  at.(18) ],
  [ "James",   "thuis",     at.(8),  at.(18) ],
  [ "Barry",   "overleg",   at.(10), at.(11, 30) ],
  [ "Arthur",  "prive",     at.(10), at.(11, 15) ],
  [ "Joost",   "bij_klant", at.(9),  at.(14) ],
  [ "Maarten", "vakantie",  at.(0),  at.(23, 59) ],
  [ "Sam",     "ziek",      at.(0),  at.(23, 59) ]
]

events.each_with_index do |(name, status, starts_at, ends_at), i|
  CalEvent.find_or_create_by!(employee: employees[name], google_event_id: "seed-#{today}-#{i}") do |ev|
    ev.status = status
    ev.starts_at = starts_at
    ev.ends_at = ends_at
    ev.all_day = starts_at.hour.zero?
  end
end

# Ticketdienst today: two people, one of them misspelled on purpose
[ [ "Nesli", employees["Nesli"] ], [ "Tobias", employees["Tobias"] ] ].each do |raw_name, employee|
  Ticketdienst.find_or_create_by!(date: today, raw_name: raw_name) do |t|
    t.employee = employee
    t.google_event_id = "seed-ticketdienst-#{today}"
  end
end

puts "Seeded #{Employee.count} employees, #{CalEvent.count} events, #{Ticketdienst.count} ticketdienst rows"
