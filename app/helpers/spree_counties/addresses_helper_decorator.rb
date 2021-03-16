module SpreeCounties
  module AddressesHelperDecorator
    def address_county(form, state, address_id = 'b')
      have_counties = state&.counties&.any?
      county_elements = [
        form.collection_select(:county_id, state&.counties&.order(:name) || [],
                               :id, :name,
                               { prompt: '' },
                               class: ['required', 'spree-flat-select'].compact,
                               aria: { label: Spree.t(:county) },
                               disabled: !have_counties) +
          form.label(Spree.t(:county).downcase,
                     raw(Spree.t(:county) + content_tag(:abbr, " #{Spree.t(:required)}")),
                     class: ['state-select-label', 'text-uppercase'].compact,
                     id: address_id + '_state_label') +
          image_tag('arrow.svg', class: 'position-absolute spree-flat-select-arrow')
      ].join.tr('"', "'").delete("\n")

      content_tag(:noscript, form.text_field(:county_name, class: 'required')) +
        javascript_tag("document.write(\"<span class='d-block position-relative'>#{county_elements.html_safe}</span>\");")
    end

    def address_country(form, address_id = 'b')
      country_elements = [
        form.collection_select(:country_id, available_countries,
                               :id, :name,
                               { prompt: '' },
                               class: ['required', 'spree-flat-select'].compact,
                               aria: { label: Spree.t(:country) }) +
          form.label(Spree.t(:country).downcase,
                     raw(Spree.t(:country) + content_tag(:abbr, " #{Spree.t(:required)}")),
                     class: ['state-select-label', 'text-uppercase'].compact,
                     id: address_id + '_state_label') +
          image_tag('arrow.svg', class: 'position-absolute spree-flat-select-arrow')
      ].join.tr('"', "'").delete("\n")

      content_tag(:noscript, form.text_field(:country_name, class: 'required')) +
        javascript_tag("document.write(\"<span class='d-block position-relative'>#{country_elements.html_safe}</span>\");")
    end

    def address_state(form, country, address_id = 'b')
      country ||= Spree::Country.find(Spree::Config[:default_country_id])
      have_states = country.states.any?
      state_elements = [
        form.collection_select(:state_id, country.states.order(:name),
                               :id, :name,
                               { prompt: '' },
                               class: ['required', 'spree-flat-select'].compact,
                               aria: { label: Spree.t(:state) }) +
          form.text_field(:state_name,
                          class: ['hidden', 'spree-flat-input'].compact,
                          aria: { label: Spree.t(:state) },
                          disabled: have_states,
                          placeholder: Spree.t(:state) + " #{Spree.t(:required)}") +
          form.label(Spree.t(:state).downcase,
                     raw(Spree.t(:state) + content_tag(:abbr, " #{Spree.t(:required)}")),
                     class: [have_states ? 'state-select-label' : nil, ' text-uppercase'].compact,
                     id: address_id + '_state_label') +
          image_tag('arrow.svg',
                    class: 'position-absolute spree-flat-select-arrow')
      ].join.tr('"', "'").delete("\n")

      content_tag(:noscript, form.text_field(:state_name, class: 'required')) +
        javascript_tag("document.write(\"<span class='d-block position-relative'>#{state_elements.html_safe}</span>\");")
    end

    def address_city(form, address_id = 'b')
      city_elements = [
        form.select(:city, available_cities, {}, { class: ['required', 'spree-flat-select'].compact }) +
          form.label(Spree.t(:city).downcase,
                     raw(Spree.t(:city) + content_tag(:abbr, " #{Spree.t(:required)}")),
                     class: ['state-select-label', 'text-uppercase'].compact,
                     id: address_id + '_state_label') +
          image_tag('arrow.svg', class: 'position-absolute spree-flat-select-arrow')
      ].join.tr('"', "'").delete("\n")

      content_tag(:noscript, form.text_field(:city, class: 'required')) +
        javascript_tag("document.write(\"<span class='d-block position-relative'>#{city_elements.html_safe}</span>\");")
    end

    def available_cities
      options_for_select(Spree::Address::CITIES)
    end

    Spree::AddressesHelper.prepend(self)
  end
end
