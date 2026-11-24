# builds a demo day on the board, with times relative to NOW
# to run:  bin/rails demo:day                         (scenario "normaal")
#          SCENARIO=thuisdag bin/rails demo:day
#          SCENARIO=vergaderdag bin/rails demo:day
# only works in development
#
# everyone NOT listed in a scenario has no event and shows as "Op kantoor".
# times are [status, from, to] in hours relative to the current hour;
# nil, nil = all day.

namespace :demo do
  desc "Rebuild today's board with a demo scenario (SCENARIO=normaal|thuisdag|vergaderdag)"
  task day: :environment do
    abort "Only for development!" unless Rails.env.development?

    scenarios = {
      # mixed day: a bit of everything
      "normaal" => {
        events: {
          "James"   => [ "thuis",     nil, nil ],
          "Sam"     => [ "thuis",     nil, nil ],
          "Arthur"  => [ "overleg",   0,   2 ],
          "Barry"   => [ "overleg",   0,   2 ],
          "Maarten" => [ "bij_klant", -2,  3 ],
          "Joost"   => [ "vakantie",  nil, nil ],
          "Wouter"  => [ "ziek",      nil, nil ]
        },
        on_duty: %w[Nesli Tobias]
      },

      # most people at home: "Werkt thuis" gets long,
      # both people on duty are home -> "Niemand beschikbaar" warning
      "thuisdag" => {
        events: {
          "Arthur" => [ "thuis", nil, nil ],
          "Barry"  => [ "thuis", nil, nil ],
          "Esther" => [ "thuis", nil, nil ],
          "James"  => [ "thuis", nil, nil ],
          "Joost"  => [ "thuis", nil, nil ],
          "Sam"    => [ "thuis", nil, nil ],
          "Tobias" => [ "thuis", nil, nil ],
          "Wouter" => [ "thuis", nil, nil ]
        },
        on_duty: %w[Tobias Sam]
      },

      # big meeting: "In overleg" and "Op kantoor" both get long,
      # plus client visits, a private appointment and someone sick
      "vergaderdag" => {
        events: {
          "Arthur"     => [ "overleg",   0,  2 ],
          "Barry"      => [ "overleg",   0,  2 ],
          "James"      => [ "overleg",   0,  2 ],
          "Nesli"      => [ "overleg",   0,  2 ],
          "Sam"        => [ "overleg",   0,  2 ],
          "Tobias"     => [ "overleg",   0,  2 ],
          "Wouter"     => [ "overleg",   0,  2 ],
          "Maarten"    => [ "bij_klant", -1, 4 ],
          "Willem-Jan" => [ "bij_klant", -1, 4 ],
          "Esther"     => [ "prive",     -1, 1 ],
          "Joost"      => [ "ziek",      nil, nil ]
        },
        on_duty: %w[Nesli Barry]
      }
    }

    name = ENV.fetch("SCENARIO", "normaal")
    scenario = scenarios.fetch(name) do
      abort "Unknown scenario '#{name}'. Choose from: #{scenarios.keys.join(', ')}"
    end

    today = Time.zone.today
    hour  = Time.current.beginning_of_hour

    ActiveRecord::Base.transaction do
      # start with a clean day
      CalEvent.where(starts_at: today.all_day).destroy_all
      Ticketdienst.where(date: today).delete_all

      scenario[:events].each do |employee_name, (status, from, to)|
        all_day = from.nil?
        CalEvent.create!(
          employee: Employee.find_by!(name: employee_name),
          google_event_id: "demo-#{employee_name.downcase}-#{today}",
          status: status,
          all_day: all_day,
          starts_at: all_day ? today.beginning_of_day : hour + from.hours,
          ends_at:   all_day ? today.end_of_day       : hour + to.hours
        )
      end

      scenario[:on_duty].each do |employee_name|
        Ticketdienst.create!(
          date: today,
          raw_name: employee_name,
          employee: Employee.find_by!(name: employee_name),
          google_event_id: "demo-ticketdienst-#{today}"
        )
      end
    end

    puts "Demo day ready: #{name}"
  end
end
