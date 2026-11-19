# builds a demo day on the board, with times relative to NOW
# to run:  bin/rails demo:day
# only works in development

namespace :demo do
  desc "Rebuild today's board with the demo setup, with times relative to now"
  task day: :environment do
    abort "Only for development!" unless Rails.env.development?

    # everyone NOT listed here has no event and therefore shows as "Op kantoor":
    # nesli, willem-Jan, esther, tobias

    setup = {
      # werkt thuis
      "James"   => [ "thuis",     nil, nil ],
      "Sam"     => [ "thuis",     nil, nil ],

      # in overleg (also shown in op kantoor)
      "Arthur"  => [ "overleg",   0,   2 ],
      "Barry"   => [ "overleg",   0,   2 ],

      # bij klant
      "Maarten" => [ "bij_klant", -2,  3 ],

      # afwezig
      "Joost"   => [ "vakantie",  nil, nil ],   # "Vakantie"
      "Wouter"  => [ "ziek",      nil, nil ]    # gewoon "Afwezig"
    }

    # ticketdienst
    on_duty = %w[Nesli Tobias]

    today = Time.zone.today
    hour  = Time.current.beginning_of_hour

    ActiveRecord::Base.transaction do
      # start with a clean day
      CalEvent.where(starts_at: today.all_day).destroy_all
      Ticketdienst.where(date: today).delete_all

      setup.each do |name, (status, from, to)|
        all_day = from.nil?
        CalEvent.create!(
          employee: Employee.find_by!(name: name),
          google_event_id: "demo-#{name.downcase}-#{today}",
          status: status,
          all_day: all_day,
          starts_at: all_day ? today.beginning_of_day : hour + from.hours,
          ends_at:   all_day ? today.end_of_day       : hour + to.hours
        )
      end

      on_duty.each do |name|
        Ticketdienst.create!(
          date: today,
          raw_name: name,
          employee: Employee.find_by!(name: name),
          google_event_id: "demo-ticketdienst-#{today}"
        )
      end
    end

    puts "Demo day ready"
  end
end
