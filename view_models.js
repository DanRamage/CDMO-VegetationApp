base_view_model = function(parent_model_view)
{
  var self = this;
  //Active and view states
  self.active = ko.observable(false);
  self.visible = ko.observable(false);
  self.initialized = ko.observable(false);

  self.parent_model_view = parent_model_view;

  self.initialize = function()
  {
    return;
  };
  self.activate_tab = function(activate_flag)
  {
    if(activate_flag)
    {
      self.visible(true);
      self.active(true);
      self.initialized(true);
    }
    else
    {
      self.visible(false);
    }
  };
}


function dataset_type_view(parent_model_view)
{
  var self = this;
  base_view_model.call(self, parent_model_view);
  self.active(true);
  self.visible(true);
  self.submerged = false;
  self.emergent = false;
  self.magrove = false;
  //These enable/disable the buttons depending on whether the category has data.
  self.mangroves_has_data = ko.observable(false);
  self.submerged_has_data = ko.observable(false);
  self.emergent_has_data = ko.observable(false);

  self.submerged_aquatic_click = function(parent_view)
  {
    self.submerged = true;
    self.emergent = false;
    self.mangrove = false;

    self.goto_reserve_tab("Submerged Aquatic Vegetation", parent_view);

  };
  self.emergent_click = function(parent_view)
  {
    self.submerged = false;
    self.emergent = true;
    self.mangrove = false;

    self.goto_reserve_tab("Marsh Vegetation", parent_view);

  };
  self.mangrove_click = function(parent_view)
  {
    self.submerged = false;
    self.emergent = false;
    self.mangrove = true;

    self.goto_reserve_tab("Mangroves", parent_view);
  };
  self.goto_reserve_tab = function(data_type_name, parent_view)
  {
    var view_model = parent_view.get_tab_view_model('reserve');
    view_model.set_data_type_selected(data_type_name);
    //view_model.data_type_selected_text(data_type_name);
    //view_model.reset_selections();
    parent_view.activate_tab('reserve');
  }
}


function reserves_view(parent_model_view)
{
  var self = this;
  base_view_model.call(self, parent_model_view);
  self.data_type_selected_text = ko.observable(""); //Data button from first tab.

  self.reserves = ko.observableArray([]);

  self.initialize = function(reserves_data)
  {
    if(reserves_data !== undefined)
    {
      self.set_reserves_data(reserves_data);
    }
  };

  self.process_data = function(reserves_data)
  {
    if(reserves_data)
    {
      self.set_reserves_data(reserves_data);
    }
    //Multiselect control: http://davidstutz.github.io/bootstrap-multiselect/
    $.each(self.reserves(), function(ndx, reserve) {
      var m_sel = $('#' + reserve.reserve_code + '-years-col > m_sel');
      m_sel.multiselect();
    });
  };
  self.set_reserves_data = function(reserves_data)
  {
    var dataset_vm = self.parent_model_view.get_tab_view_model('dataset_type');
    $.each(reserves_data.reserves, function(ndx, reserve)
    {
      try
      {
        var mangrove_years = [];
        $.each(reserve.Mangroves, function(ndx, year)
        {
          mangrove_years.push({'year' : year});
        });
        var submergedaquaticvegetation_years = [];
        $.each(reserve.SubmergedAquaticVegetation, function(ndx, year)
        {
          submergedaquaticvegetation_years.push({'year' : year});
        });

        var marshvegetation_years = [];
        $.each(reserve.MarshVegetation, function(ndx, year)
        {
          marshvegetation_years.push({'year' : year});
        });

        //Enable the buttons if we have data for the category.
        if(mangrove_years.length)
        {
          dataset_vm.mangroves_has_data(true);
        }
        if(submergedaquaticvegetation_years.length)
        {
          dataset_vm.submerged_has_data(true);
        }
        if(marshvegetation_years.length)
        {
          dataset_vm.emergent_has_data(true);
        }


        reserve.years = new ko.observableArray([]);
        reserve.selected_years = new ko.observableArray([]);
        reserve.mangrove = mangrove_years;
        reserve.submergedaquaticvegetation = submergedaquaticvegetation_years;
        reserve.marshvegetation = marshvegetation_years;

        self.reserves().push(reserve);
      }
      catch(err)
      {
        console.log(err);
      }
    });


  };
  self.add_years = function(year_array, reserve_obj)
  {
    $.each(year_array, function(ndx, year) {
      reserve_obj.years.push(year);
    });
  };
  self.set_data_type_selected = function(data_type_name)
  {
    self.reset_selections();

    self.data_type_selected_text(data_type_name);
    $.each(self.reserves(), function(ndx, reserve) {
        reserve.years.removeAll();
        if(self.data_type_selected_text() === "Mangroves")
        {
          self.add_years(reserve.mangrove, reserve);
        }
        else if(self.data_type_selected_text() === "Marsh Vegetation")
        {
          self.add_years(reserve.marshvegetation, reserve);
        }
        else if(self.data_type_selected_text() === "Submerged Aquatic Vegetation")
        {
          self.add_years(reserve.submergedaquaticvegetation, reserve);
        }
    });
    self.reserves.valueHasMutated();
  };
  self.reset_selections = function()
  {
    $.each(self.reserves(), function (ndx, reserve) {
      reserve.selected_years.removeAll();
    });
  };
  self.is_data_selected = function()
  {
    var ret_val = false;
    $.each(self.reserves(), function (ndx, reserve) {
      if (reserve.selected_years().length) {
        ret_val = true;
        return;
      }
    });
    return(ret_val);
  };
  self.selection_complete_click = function(parent_view)
  {
    parent_view.activate_tab('send_receive');
  };
  self.get_user_selections = function()
  {
    var user_selections = [];
    $.each(self.reserves(), function (ndx, reserve) {
      if(reserve.selected_years().length) {
        user_selections.push({
          'data_type': self.data_type_selected_text().replace(/ /g, ""), //remove spaces.
          'reserve_code': reserve.reserve_code,
          'selected_years': reserve.selected_years.slice(0)
        });
      }
    });
    return(user_selections);
  }
}


function send_receive_view(parent_model_view)
{
  var self = this;
  base_view_model.call(self, parent_model_view);
  self.first_name = ko.observable("");
  self.last_name = ko.observable("");
  self.email_addr = ko.observable("");
  self.organization = ko.observable("");
  self.occupation = ko.observable("");
  self.purpose = ko.observable("");
  self.comments = ko.observable("");
  $(document).ready(function() {
    $('#use_data').validator({disable: false,
                              input_group: '.form-input-group'});
    /*
    $('#use_data').bootstrapValidator({
        feedbackIcons: {
          valid: 'glyphicon glyphicon-ok',
          invalid: 'glyphicon glyphicon-remove',
          validating: 'glyphicon glyphicon-refresh'
        },
      fields: {
        first_name: {
          group: '.col-md-4',
          validators: {
            notEmpty: {
              message: 'Please enter a First Name'
            },
            stringLength: {
              max: 32,
              message: 'The first name must be less than 32 characters long'
            }
          }
        },
        last_name: {
          group: '.col-md-4',
          validators: {
            notEmpty: {
              message: 'Please enter Last Name'
            },
            stringLength: {
              max: 32,
              message: 'The last name must be less than 32 characters long'
            }
          }
        },
        email_addr: {
          group: '.col-md-4',
          validators: {
            notEmpty: {
              message: 'Please enter a valid email address '
            }
          }
        },
        organization: {
          group: '.col-md-4',
          validators: {
            notEmpty: {
              message: 'Please enter your organization'
            },
            stringLength: {
              max: 64,
              message: 'The organization must be less than 32 characters long'
            }
          }
        },
        occupation: {
          group: '.col-md-4',
          validators: {
            notEmpty: {
              message: 'Please enter your occupation selection'
            }
          }
        },
        purpose: {
          group: '.col-md-4',
          validators: {
            notEmpty: {
              message: 'Please enter the your intended data use'
            }
          }
        },
        staff: {
          // The group will be set as default (.form-group)
          validators: {
            notEmpty: {
                message: 'Please make a staff selection.'
            }
          }
        }
      }
    });

    //Prevent bootstrapValidator from submitting the form twice.
    $('use_data').on('success.form.fv', function(e) {
      // Prevent form submission
      e.preventDefault();
    });
    */
  });

  $('#use_data').validator().on('submit', function (e) {
    if(!e.isDefaultPrevented())
    {
      var ret_val = $('#use_data').validator('validate');
      var reserves_model = self.parent_model_view.get_tab_view_model("reserve");
      var user_selection = reserves_model.get_user_selections();
      if(user_selection.length == 0)
      {
        self.parent_model_view.popup_title("Request Failed");
        self.parent_model_view.popup_message("You did not select any reserves or years for data.");
        $('#message_popup').modal("show");
        return(false);

      }
      var post_data = $('#use_data').serialize();
      var reserve_rec = "";
      $.each(user_selection, function(ndx, reserve) {
        if(reserve_rec.length)
        {
          reserve_rec += "~";
        }
        reserve_rec += reserve.reserve_code + ";" + reserve.selected_years.join() + ";" + reserve.data_type;
      });
      post_data += "&reserve_codes=" + reserve_rec;
      self.parent_model_view.popup_title("Submitting Request");
      self.parent_model_view.popup_message("Your request is being submitted.");
      $('#message_popup').modal({ backdrop: 'static', keyboard: false, scope: this })
        .one('click', '#message_popup_close_btn', function (e) {
          var reserve_obj = self.parent_model_view.get_tab_view_model('reserve');
          reserve_obj.set_data_type_selected("");
          self.parent_model_view.reset_tab_active_states();
          $('#veg_tabs a[href="#dataset_type"]').tab('show');
        });
      //$('#message_popup').modal("show");
      $.post('veg_app_request_handler.cfm',post_data,function(data,status){
        self.parent_model_view.popup_title("Request received");
        self.parent_model_view.popup_message(data);
      });
    }
    //Disable the submit button.
    //$('#use_data').closest('form').find(':submit').attr('disabled','disabled');
    e.preventDefault();
  });

  /*
  self.sendForm = function(form_elements)
  {
    var ret_val = $('#use_data').validator('validate');
    var reserves_model = self.parent_model_view.get_tab_view_model("reserve");
    var user_selection = reserves_model.get_user_selections();
    if(user_selection.length == 0)
    {
      self.parent_model_view.popup_title("Request Failed");
      self.parent_model_view.popup_message("You did not select any reserves or years for data.");
      $('#message_popup').modal("show");
      return(false);

    }
    var post_data = $(form_elements).serialize();
    var reserve_rec = "";
    $.each(user_selection, function(ndx, reserve) {
      if(reserve_rec.length)
      {
        reserve_rec += "~";
      }
      reserve_rec += reserve.reserve_code + ";" + reserve.selected_years.join() + ";" + reserve.data_type;
    });
    post_data += "&reserve_codes=" + reserve_rec;
    self.parent_model_view.popup_title("Submitting Request");
    self.parent_model_view.popup_message("Your request is being submitted.");
    $('#message_popup').modal("show");
    $.post('veg_app_request_handler.cfm',post_data,function(data,status){
      self.parent_model_view.popup_title("Request received");
      self.parent_model_view.popup_message(data);
    });
    return(false);
  }
  */
  /*
  $('use_data').validate({
    rules : {
      first_name: {
        min_length: 1,
          max_length : 30,
          required: true
      },
      last_name: {
        min_length: 1,
          max_length: 30,
          required: true
      }
    }
   }
  );
  */

}


function view_model()
{
  var self = this;

  self.popup_title = ko.observable();
  self.popup_message = ko.observable();

  self.tab_states = ko.observableArray([
    {about:{ view_model: null}},
    {dataset_type:{ view_model: null}},
    {reserve: {view_model: null}},
    {send_receive: {view_model: null}}
  ]);

  self.initialize = function(reserves_data)
  {
    //ko.applyBindings(this);

    var view_obj = self.find_tab_obj('about');
    if(view_obj !== null)
    {
      view_obj['about'].view_model = new base_view_model(self);
      view_obj['about'].view_model.initialize();
      view_obj['about'].view_model.activate_tab(true);
    }

    view_obj = self.find_tab_obj('dataset_type');
    if(view_obj !== null)
    {
      view_obj['dataset_type'].view_model = new dataset_type_view(self);
      view_obj['dataset_type'].view_model.initialize();
    }

    view_obj = self.find_tab_obj('reserve');
    if(view_obj !== null)
    {
      view_obj['reserve'].view_model = new reserves_view(self);
      view_obj['reserve'].view_model.initialize(reserves_data);
    }

    view_obj = self.find_tab_obj('send_receive');
    if(view_obj !== null)
    {
      view_obj['send_receive'].view_model = new send_receive_view(self);
      view_obj['send_receive'].view_model.initialize();
    }

    $('#veg_tabs a').click(self.tab_click);
  };
  self.reset_tab_active_states = function()
  {
    var view = self.get_tab_view_model('reserve');
    view.active(false);
    var view = self.get_tab_view_model('send_receive');
    view.active(false);

  };
  self.activate_tab = function(name)
  {
    $.each(self.tab_states(), function(ndx, tab_model)
    {
      //Found the correct model? Activate the tab.
      if(name in tab_model)
      {
        tab_model[name].view_model.activate_tab(true);
        var tab_id = "#" + name;
        $('#veg_tabs a[href=\"' + tab_id + '\"]').tab('show');
      }
      else
      {
        var key = Object.keys(tab_model);
        tab_model[key[0]].view_model.activate_tab(false);
      }
    });
  };

  self.tab_click = function(e)
  {
    e.preventDefault();

    //If the user has made selections and they aer clicking back on a tab, let them know
    //there selections will be lost if they go back to the dataset type tab.
    var reserve_obj = self.get_tab_view_model('reserve');
    if(reserve_obj !== null)
    {
      //Get the id of the tab.
      var tab_id = $(this).attr('href');
      if(tab_id !== undefined)
      {
        //Strip the # out to get the ID of the panel we want to activate.
        tab_id = tab_id.replace('#', '');
        if(tab_id === 'dataset_type')
        {
          if (reserve_obj.data_type_selected_text().length > 0 && reserve_obj.is_data_selected())
          {
            //$('#ok_cancel_modal').modal("show");
            $('#ok_cancel_modal').modal({ backdrop: 'static', keyboard: false, tab_scope: this })
              .one('click', '#ok_cancel_ok_btn', function (e) {
                var options = $('#ok_cancel_modal').data('bs.modal').options;
                var reserve_obj = self.get_tab_view_model('reserve');
                self.reset_tab_active_states();
                reserve_obj.set_data_type_selected("");
                var tab_scope = options.tab_scope;
                self.tab_change(tab_scope);
              });
          }
          else
          {
            self.tab_change(this);
          }
        }
        else
        {
          self.tab_change(this);
        }
      }
    }
    else
    {
      self.tab_change(this);
    }
  };
  self.tab_change = function(tab_scope)
  {
    var tab_id = $(tab_scope).attr('href');
    if(tab_id !== undefined)
    {
      //Strip the # out to get the ID of the panel we want to activate.
      tab_id = tab_id.replace('#', '');

      var view_model = self.get_tab_view_model(tab_id);
      if(view_model.active())
      {
        $(tab_scope).tab('show');
      }
    }
  };
  self.find_tab_obj = function(tab_name)
  {
    var match = ko.utils.arrayFirst(self.tab_states(), function(item)
    {
        //return tab_name === item.id;
      if(tab_name in item)
      {
        return(true);
      }
      return(false);
    });
    return(match);
  };
  self.get_tab_view_model = function(tab_name)
  {
    var tab = self.find_tab_obj(tab_name);
    if(tab)
    {
      return(tab[tab_name].view_model);
    }
    return(null);
  };
  self.get_data_download_type = function() {
    var view_obj = self.find_tab_obj('dataset_type');
    if (view_obj) {
      var view_model = view_obj['dataset_type'];
      if (view_model.submerged) {
        return("Submerged Aquatic");
      }
      else if (view_model.emergent) {
        return("Emergent");
      }
      else if (view_model.magrove) {
        return("Mangrove");
      }
    }
    return("None");
  }
  /*
  self.tab_activate(tab_name)
  {
    if(tab_name in self.tab_states)
    {
      $.each(self.tab_states, function(key, tab_data))
      {
        if(tab_name == key)
        {
          self.tab_states[tab_name].active(true);
        }
        else
        {
          self.tab_states[key].active(false);
        }

      }
    }
  }
  */

}