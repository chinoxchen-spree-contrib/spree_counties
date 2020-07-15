Spree.ready(function($) {
  var getStateId;
  if (($('#checkout_form_address')).is('*')) {
    getStateId = function(region) {
      return $('#' + region + 'state select').val();
    };
    Spree.updateCounty = function(region) {
      var countyInput, countyPara, countySelect, stateId;
      stateId = getStateId(region);
      if ((stateId != null) && stateId) {
        if (Spree.Checkout[stateId] == null) {
          return $.get('/api/counties', {
            state_id: stateId
          }, function(data) {
            Spree.Checkout[stateId] = {
              counties: data.counties,
              counties_required: false
            };
            return Spree.fillCounties(Spree.Checkout[stateId], region);
          });
        } else {
          return Spree.fillCounties(Spree.Checkout[stateId], region);
        }
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
    $(document).on('change', '#bstate select', function() {
      return Spree.updateCounty('b');
    });
    $(document).on('change', '#sstate select', function() {
      return Spree.updateCounty('s');
    });
    $(document).on('change', '#bcountry select', function() {
      return Spree.updateCounty('b');
    });
    $(document).on('change', '#scountry select', function() {
      return Spree.updateCounty('s');
    });
    Spree.updateCounty('b');
    Spree.updateCounty('s');
    window.fillStatesOld = Spree.fillStates;
    return Spree.fillStates = function(data, region) {
      fillStatesOld(data, region);
      return Spree.updateCounty(region);
    };
  }
});
