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
    { title: "Op kantoor",     statuses: %w[kantoor] },
    { title: "Werkt thuis",    statuses: %w[thuis] },
    { title: "In overleg",     statuses: %w[overleg] },
    { title: "Bij klant",      statuses: %w[bij_klant] },
    { title: "Privé afspraak", statuses: %w[prive] },
    { title: "Afwezig",        statuses: %w[vakantie ziek afwezig] }
  ].freeze

  def status_badge(status)
    display = STATUS_DISPLAY.fetch(status)
    tag.span(display[:label], class: "badge text-bg-#{display[:color]}")
  end

    NOT_AVAILABLE_FOR_DUTY = %w[thuis vakantie ziek afwezig].freeze

  def available_for_duty?(ticketdienst, statuses)
    ticketdienst.employee.present? &&
      !NOT_AVAILABLE_FOR_DUTY.include?(statuses[ticketdienst.employee])
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
