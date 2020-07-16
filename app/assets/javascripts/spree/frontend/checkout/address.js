Spree.ready(function ($) {
  Spree.CheckoutCounties = {};
  Spree.onAddress = function () {
    if ($('#checkout_form_address').length) {

      Spree.updateState = function (region) {
        var countryId = getCountryId(region);
        if (countryId != null) {
          if (Spree.Checkout[countryId] == null) {
            $.ajax({
              async: false, method: 'GET', url: Spree.pathFor('/api/v2/storefront/countries/' + countryId + '?include=states'), dataType: 'json'
            }).done(function (data) {
              var json = data.included; var xStates = [];
              for (var i = 0; i < json.length; i++) {
                var obj = json[i]; xStates.push({ 'id': obj.id, 'name': obj.attributes.name })
              }
              Spree.Checkout[countryId] = {
                states: xStates,
                states_required: data.data.attributes.states_required,
                zipcode_required: data.data.attributes.zipcode_required
              };
              Spree.fillStates(Spree.Checkout[countryId], region);
              Spree.toggleZipcode(Spree.Checkout[countryId], region);
              Spree.updateCounty(region);
            })
          } else {
            Spree.fillStates(Spree.Checkout[countryId], region);
            Spree.toggleZipcode(Spree.Checkout[countryId], region)
            Spree.updateCounty(region);
          }
        }
      };

      Spree.updateCounty = function(region) {
        var stateId = getStateId(region);
        if (stateId != null) {
          if (Spree.CheckoutCounties[stateId] == null) {
            return $.get('/api/counties', {
              state_id: stateId
            }, function(data) {
              Spree.CheckoutCounties[stateId] = {
                counties: data.counties,
                counties_required: false
              };
              return Spree.fillCounties(Spree.CheckoutCounties[stateId], region);
            });
          } else {
            return Spree.fillCounties(Spree.CheckoutCounties[stateId], region);
          }
        }
      };

      Spree.toggleZipcode = function (data, region) {
        var requiredIndicator = $('span#required_marker').first().text()
        var zipcodeRequired = data.zipcode_required
        var zipcodePara = $('#' + region + 'zipcode')
        var zipcodeInput = zipcodePara.find('input')
        var zipcodeLabel = zipcodePara.find('label')
        var zipcodeLabelText = zipcodeInput.attr('aria-label')

        if (zipcodeRequired) {
          var zipText = zipcodeLabelText + ' ' + requiredIndicator
          zipcodeInput.prop('required', true).attr('placeholder', zipText)
          zipcodeLabel.text('')
          zipcodeLabel.text(zipText)
          zipcodeInput.addClass('required')
        } else {
          zipcodeInput.prop('required', false).attr('placeholder', zipcodeLabelText)
          zipcodeLabel.text('')
          zipcodeLabel.text(zipcodeLabelText)
          zipcodeInput.removeClass('required')
        }
      }

      Spree.fillStates = function (data, region) {
        var selected;
        var statesRequired = data.states_required;
        var states = data.states;
        var statePara = $('#' + region + 'state');
        var stateSelect = statePara.find('select');
        var stateInput = statePara.find('input');
        var stateLabel = statePara.find('label');
        var stateSelectImg = statePara.find('img');
        var stateSpanRequired = statePara.find('abbr');

        if (states.length > 0) {
          selected = parseInt(stateSelect.val());
          stateSelect.html('');
          $.each(states, function (idx, state) {
            var opt = $(document.createElement('option')).attr('value', state.id).html(state.name)
            if (selected.toString(10) === state.id.toString(10)) {
              opt.prop('selected', true)
            }
            stateSelect.append(opt)
          });
          stateSelect.prop('required', false);
          stateSelect.prop('disabled', false).show();
          stateLabel.addClass('state-select-label');
          stateInput.hide().prop('disabled', true);
          statePara.show();
          stateSpanRequired.hide();
          stateSelect.removeClass('required');

          if (statesRequired) {
            stateSelect.addClass('required')
            stateSelectImg.show()
            stateSpanRequired.show()
            stateSelect.prop('required', true)
          }
          stateSelect.removeClass('hidden');
          stateInput.removeClass('required')
        } else {
          stateSelect.hide().prop('disabled', true);
          stateLabel.removeClass('state-select-label');
          stateSelectImg.hide();
          stateInput.show();
          if (statesRequired) {
            stateSpanRequired.show();
            stateLabel.removeClass('state-select-label');
            stateInput.addClass('required form-control')
          } else {
            stateInput.val('');
            stateSpanRequired.hide();
            stateInput.removeClass('required')
          }
          statePara.toggle(!!statesRequired);
          stateInput.prop('disabled', !statesRequired);
          stateInput.removeClass('hidden');
          stateSelect.removeClass('required')
        }
      };

      Spree.fillCounties = function(data, region) {
        var counties, countiesRequired, countyInput, countyPara, countySelect, countySpanRequired, countyWithBlank, selected;
        countiesRequired = data.counties_required;
        counties = data.counties;
        countyPara = $('#' + region + 'county');
        countySelect = countyPara.find('select');
        countyInput = countyPara.find('input');
        countySpanRequired = countyPara.find('[id$="county-required"]');
        if (counties.length > 0) {
          selected = parseInt(countySelect.val());
          countySelect.html('');
          countyWithBlank = [
            {
              name: '',
              id: ''
            }
          ].concat(counties);
          $.each(countyWithBlank, function(idx, county) {
            var opt;
            opt = ($(document.createElement('option'))).attr('value', county.id).html(county.name);
            if (selected === county.id) {
              opt.prop('selected', true);
            }
            return countySelect.append(opt);
          });
          countySelect.prop('disabled', false).show();
          countyInput.hide().prop('disabled', true).val('');
          countyPara.show();
          countySpanRequired.show();
          if (countiesRequired) {
            countySelect.addClass('required');
          }
          countySelect.removeClass('hidden');
          return countyInput.removeClass('required');
        } else {
          countySelect.hide().prop('disabled', true).val('');
          countyInput.show();
          if (countiesRequired) {
            countySpanRequired.show();
            countyInput.addClass('required');
          } else {
            countyInput.val('');
            countySpanRequired.hide();
            countyInput.removeClass('required');
          }
          countyPara.toggle(!!countiesRequired);
          countyInput.prop('disabled', !countiesRequired);
          countyInput.removeClass('hidden');
          return countySelect.removeClass('required');
        }
      };

      $('#bcountry select').change(function () {
        Spree.updateState('b')
      });
      $('#scountry select').change(function () {
        Spree.updateState('s')
      });

      $('#sstate select').change(function () {
        Spree.updateCounty('s')
      });

      $('#bstate select').change(function () {
        Spree.updateCounty('s')
      });

      var orderUseBilling = $('input#order_use_billing');
      orderUseBilling.change(function () {
        updateShippingFormState(orderUseBilling)
      });

      if (orderUseBilling.length > 0) {
        Spree.updateState('b');
        updateShippingFormState(orderUseBilling)
      } else {
        Spree.updateState('s')
      }

    }
    function updateShippingFormState (orderUseBilling) {
      if (orderUseBilling.is(':checked')) {
        $('#shipping .inner').hide();
        $('#shipping .inner input, #shipping .inner select').prop('disabled', true)
      } else {
        $('#shipping .inner').show();
        $('#shipping .inner input, #shipping .inner select').prop('disabled', false)
        Spree.updateState('s')
      }
    }
    function getCountryId (region) {
      return $('#' + region + 'country select').val();
    }

    function getStateId (region) {
      return $('#' + region + 'state select').val();
    }
  };
  Spree.onAddress()
});
