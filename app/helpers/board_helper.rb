module BoardHelper
  STATUS_DISPLAY = {
    "kantoor"   => { label: "Op kantoor",     color: "info" },
    "thuis"     => { label: "Werkt thuis",    color: "primary" },
    "bij_klant" => { label: "Bij klant",      color: "success" },
    "prive"     => { label: "Privé afspraak", color: "warning" },
    "overleg"   => { label: "In overleg",     color: "secondary" },
    "vakantie"  => { label: "Vakantie",       color: "light" },
    "ziek"      => { label: "Afwezig",        color: "light" },
    "afwezig"   => { label: "Afwezig",        color: "light" }
  }.freeze

   ZONES = [
    { key: "kantoor",   icon: "office",    title: "Op kantoor",     statuses: %w[kantoor] },
    { key: "thuis",     icon: "home",      title: "Werkt thuis",    statuses: %w[thuis] },
    { key: "overleg",   icon: "chat",      title: "In overleg",     statuses: %w[overleg] },
    { key: "bij-klant", icon: "handshake", title: "Bij klant",      statuses: %w[bij_klant] },
    { key: "prive",     icon: "clock",     title: "Privé afspraak", statuses: %w[prive] },
    { key: "afwezig",   icon: "away",      title: "Afwezig",        statuses: %w[vakantie ziek afwezig] }
  ].freeze

  def status_badge(status)
    display = STATUS_DISPLAY.fetch(status)
    tag.span(display[:label], class: "badge text-bg-#{display[:color]}")
  end

    NOT_AVAILABLE_FOR_DUTY = %w[thuis vakantie ziek afwezig].freeze

  def available_for_duty?(ticketdienst, statuses)
    ticketdienst.employee.present? &&
      (statuses.fetch(ticketdienst.employee, []) & NOT_AVAILABLE_FOR_DUTY).empty?
  end

  # People whose statuses match one of the zone's statuses (someone can be in two zones).
  def people_in(zone, statuses)
    statuses.select { |_employee, list| (list & zone[:statuses]).any? }
  end

  # The event that explains why someone is in this zone (for "tot 17:00" etc.).
  def zone_event(zone, events)
    events.find { |event| zone[:statuses].include?(event.status) }
  end

  # Short label shown next to the name.
  def status_tag(statuses)
    "Vakantie" if statuses.include?("vakantie")
  end

  # True when someone is in a meeting but shown in another zone (Op kantoor, Werkt thuis).
  def in_meeting_elsewhere?(zone, statuses)
    statuses.include?("overleg") && !zone[:statuses].include?("overleg")
  end

  def status_detail(event)
    return if event.nil? || event.all_day?

    time = localize(event.ends_at, format: "%H:%M")
    case event.status
    when "prive", "bij_klant" then "terug om #{time}"
    when "overleg" then "tot #{time}"
    end
  end
end
