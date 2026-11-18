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

  def status_badge(status)
    display = STATUS_DISPLAY.fetch(status)
    tag.span(display[:label], class: "badge text-bg-#{display[:color]}")
  end
end
