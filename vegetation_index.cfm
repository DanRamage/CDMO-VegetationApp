<!DOCTYPE html>
<html lang="en">
  <head>

    <title>Vegetation App | Centralized Data Management Office</title>

	      <link href="/core-components/styles.css?v=1.9" rel="stylesheet" type="text/css">

	<script src="https://code.jquery.com/jquery-1.10.1.min.js"></script>
	<script src="https://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>

  <link rel="stylesheet" href="https://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">

    <!-- Bootstrap core CSS -->
    <link href="../resources/js/bootstrap/bootstrap-3.3.4/css/bootstrap.min.css" rel="stylesheet">
    <link href="../resources/js/bootstrap/bootstrap-3.3.4/css/bootstrap-theme.min.css" rel="stylesheet">
    <link href="../resources/js/bootstrap/bootstrap-multiselect/dist/css/bootstrap-multiselect.css" rel="stylesheet">
    <link href="/newIncludes/Default.css" rel="stylesheet" type="text/css" media="screen" />
    <link rel="stylesheet" href="/newIncludes/stylesheet.css" type="text/css" />
    <link href="/menus/menu_style.css" type="text/css" rel="stylesheet">

    <script type="application/javascript" src="../resources/js/jquery/jquery-1.11.1.min.js"></script>
    <script type="application/javascript" src="../resources/js/bootstrap/bootstrap-3.3.4/js/bootstrap.min.js"></script>
    <script type="application/javascript" src="../resources/js/knockout/knockout-3.2.0.js"></script>
    <script type="application/javascript" src="../resources/js/bootstrap/bootstrap-validator/validator.js"></script>
    <script type="application/javascript" src="../resources/js/bootstrap/bootstrap-multiselect/dist/js/bootstrap-multiselect.js"></script>
    <script type="application/javascript" src="view_models_test.js"></script>

    <!--
    <a href='javascript:(function(){var s=document.createElement("script");s.onload=function(){bootlint.showLintReportForCurrentDocument([]);};s.src="https://maxcdn.bootstrapcdn.com/bootlint/latest/bootlint.min.js";document.body.appendChild(s)})();'>Bootlint</a>
    -->
    <!-- Custom styles for this template -->
    <style>
      body {
        font-family: "verdana";
        font-size: 12px;
        font-stretch: normal;
      }
      #about {
        font-size: 14px;
      }
      /*
      #veg_app .row {
        width: calc(100% - 970px);
      }
      */
      .app_row {
        display: table-row;
      }
      .app_container {
          width: 100%;
          display: table;
          table-layout: fixed;
      }
      .left_col
      {
        display: table-cell;
        height: 297px;
        vertical-align: top;
      }
      .right_col
      {
        display: table-cell;
        height: 297px;
        vertical-align: top;
      }
      .middle-column {
        display: table-cell;
        /*padding: 10px;*/
        width: 942px;
        vertical-align: top;
      }
      .tab-content {
          height: 620px;
          border-left: 1px solid #ddd;
          border-bottom: 1px solid #ddd;
          border-right: 1px solid #ddd;
          padding: 10px;

      }
      .cdmo_menu_col {
        padding-top: 2px;
        padding-left: 2px;
        padding-right: 2px;
        padding-bottom: 2px;
      }
      .app_body_row
      {
        background-color: #FFFFFF;
        padding-left: 15px;

        margin: 0px;
        padding: 0px;

      }
      .app_body
      {
        background-color: #FFFFFF;
        padding: 0px;
        /*
        padding-left: 10px;
        padding-right: 10px;
        padding-bottom: 10px;
        */
      }
      .header_row {
        margin: 0px;
        padding: 0px;
        /*
        margin-left: 0;
        margin-right: 0;
        padding-left: 0;
        */
      }
      .header_column {
        margin: 0px;
        padding: 0px;
        /*
        margin-left: 0;
        margin-right: 0;
        padding-left: 0;
        */
      }
      .bg_row {
        margin: 0px;
        padding: 0px;
        /*
        margin-left: 0;
        margin-right: 0;
        padding-left: 0;
        */
      }
      .bg_foot {
        padding-left: 15px;
      }
      .bg_new_left {
        background: url("../revamp/new/bg_left.gif") no-repeat scroll right top rgba(0, 0, 0, 0);
        height:100%;
        /*width: 327px;*/
      }
      .bg_new_right {
        background: url("../revamp/new/bg_right.gif") no-repeat scroll left top rgba(0, 0, 0, 0);
        height: 100%;
      }

      #veg_tabs a:link {
        text-decoration: none !important;
      }

      .nav-tabs {
          margin-bottom: 0;
      }
      .nav-tabs > li.active > a  {
        font-weight: bold;
      }
      .nav-tabs > li > a {
        color: #aab3b3;
        font-weight: bold;
        padding: 5px 10px;
      }
      .btn-help {
          position:absolute;
          background-color: transparent;
          background-image: none;
          box-shadow: none;
          border-color: #ffffff;
          /*right:2px;*/
          top:2px;
      }
      .help_question_mark-style {
        font-size: 20px;
        color: rgb(0,0,0);
      }

      #btn-marsh_veg.btn-success
      {
        background-image: linear-gradient(to bottom, #8ebc8e 0px, #8ebc80 100%);
        background-repeat: repeat-x;
        border-color: #3e8f3e;
      }
      #btn-marsh_veg.btn-success:hover,
      #btn-marsh_veg.btn-success:focus,
      #btn-marsh_veg.btn-success:active,
      #btn-marsh_veg.btn-success.active,
      .open > #btn-marsh_veg.dropdown-toggle.btn-success {
          background-color: #8ebc60;
          border-color: #398439;
          color: #fff;
      }
      #reserves_table_div {
        overflow-y: scroll;
        height: 395px;
      }
      #reserves_table > thead > tr > th,
      #reserves_table > tbody > tr > th,
      #reserves_table > tfoot > tr > th,
      #reserves_table > thead > tr > td,
      #reserves_table > tbody > tr > td,
      #reserves_table > tfoot > tr > td {
        vertical-align: middle;
      }

      .td.banner {
        vertical-align: top;
      }
      .table-striped > tbody > tr:nth-child(2n+1) > td,
      .table-striped > tbody > tr:nth-child(2n+1) > th {
        background-color: #8ebc8e;
      }
      .data_selection_complete_btn {
        margin-top: 25px;
      }
      #use_data .form-control-feedback {
          right: 15px;
      }
      #use_data .selectContainer .form-control-feedback {
          right: 30px;
      }
      #send_receive {
        font-size: 14px;
      }
      .popup_body {
        font-size: 14px;
      }
      .popup_title {
        font-size: 12px;
      }
      .form-group-no-row {
        display: none;
      }
		html,body {background-color: transparent;}
    </style>

  </head>

  <body>
	   <div id="main-wrapper">

            <cfinclude template="/core-components/header.cfm">

            <div id="content-wrapper">
    <div id="veg_app" class="app_container">
    <!--
    <div id="veg_app" class="container">
    -->
      <div class="app_row">
        <div class="left_col">
          <div class="bg_new_left"></div>
        </div>
        <div class="middle-column">
          <div class="">
            <div class="row app_body_row">
              <div class="col-xs-12">
                <div class="row">
                  <div class="col-xs-12">
                    <div class="col-xs-1"></div>
                    <div class="app_body">
                      <p>
                        <h4><b><i style="color: #198077">Vegetation Monitoring App </i><small>Powered By The Centralized Data Management Office</small></b></h4>
                      </p>
                      <ul id='veg_tabs' class="nav nav-tabs" role="tablist">
                        <li><a href="#about">About</a></li>
                        <li><a href="#dataset_type">Choose Data Type</a></li>
                        <li><a href="#reserve">Choose Reserve</a></li>
                        <li><a href="#send_receive">Submit & Receive Files</a></li>

                      </ul>
                      <div class="tab-content">
                        <!--
                        <pre data-bind="text: JSON.stringify(ko.toJS($data), null, 2)"></pre>
                        -->
                        <div class="tab-pane fade in" id="about" data-bind="with: find_tab_obj('about')['about'].view_model">
                          <div class="row">
                            <div class="col-xs-12">
                              <h3 class="text-center">Vegetation Monitoring Overview:</h3>
                              <p>
                                  The National Estuarine Research Reserve System has developed a consistent protocol for monitoring vegetation across the nation’s estuaries.  Eventually, the goal is to be monitoring vegetation regularly at every Reserve, allowing for robust spatial and temporal analyses of estuarine vegetation trends.  To date, 18 Reserves have implemented this vegetation monitoring protocol.
                              </p>
                              <p>
                                  The vegetation community that is assessed varies by reserve.  The protocol has been implemented for submerged aquatic vegetation such as eelgrass and algae, as well as for emergent vegetation such as salt marshes and mangroves.
                              </p>
                              <p>
                                  The vegetation monitoring protocol involves permanent sampling plots along fixed transects.  Parameters monitored include percent cover of all plant species, as well as stem density and canopy height of the common species. Elevation is also assessed for each plot when feasible.  The <a href="https://cdmo.baruch.sc.edu/request-manuals/">complete monitoring protocol</a> provides more details.
                              </p>
                              <p>
                                  These data will be valuable for tracking changes in abundance of particular species of interest, or in species composition over time.  For instance, the transects can be used to detect landward migration of vegetation communities in the face of projected sea level rise.
                              </p>
                              <p>
                                  To download vegetation monitoring data, please proceed to select your dataset type.
                              </p>
                            </div>
                          </div>
                        </div>

                        <!-- Begin download_type tab-->
                        <!--
                         The data-bind "with" puts the model for the download tab in "scope" for this panel. We
                         do this so we can seperate out the logic for each panel into its own model instead
                         of cramming it all into one.
                        -->
                        <div class="tab-pane fade in" id="dataset_type" data-bind="with: find_tab_obj('dataset_type')['dataset_type'].view_model">
                          <div class="row">
                            <div class="col-xs-2">
                            </div>
                            <div class="col-xs-8 text-center">
                              <h3>
                                <b>Choose your data type:</b>
                              </h3>
                            </div>
                            <div class="col-xs-2 text-center">
                              <button class="btn btn-default btn-help" data-toggle="modal" data-target="#help_modal">
                                <span class="glyphicon glyphicon-question-sign help_question_mark-style" style="display: inline-block"></span>
                              </button>
                            </div>
                          </div>
                          <hr>
                          <div class="row">
                            <div class="col-xs-12 text-center">
                              <div class="btn-group-vertical">
                                <button id="btn-submerged_aquatic" data-bind="enable: submerged_has_data(), click: function(data) { $data.submerged_aquatic_click($parents[0]) }"
                                        type="button"
                                        class="btn btn-primary btn-lg">
                                  Submerged Aquatic Vegetation
                                </button>
                                <br>
                                <button id="btn-marsh_veg" data-bind="enable: emergent_has_data(), click: function(data) { $data.emergent_click($parents[0]) }"
                                        type="button"
                                        class="btn btn-success btn-lg">
                                  Marsh Vegetation
                                </button>
                                <br>
                                <button  id="btn-mangroves" data-bind="enable: mangroves_has_data(), click: function(data) { $data.mangrove_click($parents[0]) }"
                                         type="button"
                                         class="btn btn-info btn-lg">
                                  Mangroves
                                </button>
                              </div>
                            </div>
                          </div>
                        </div>
                        <!-- End of download_type tab-->

                        <!-- Begin reserves tab -->
                        <div class="tab-pane fade in" id="reserve" data-bind="with: find_tab_obj('reserve')['reserve'].view_model">
                          <!--
                          <pre data-bind="text: JSON.stringify(ko.toJS($data), null, 2)"></pre>
                          -->
                          <div class="row">
                            <div class="col-xs-12 text-left">
                              <h3><b><span data-bind="text: data_type_selected_text"></span></b></h3>
                            </div>
                          </div>

                          <!--Reserves table row-->
                          <div class="row">
                            <div id="reserves_table_div" class="col-xs-12">
                              <table id="reserves_table" class="table table-striped">
                                <thead>
                                  <td><b>Reserve</b></td>
                                  <td><b>Reserve Code</b></td>
                                  <td><b>State</b></td>
                                  <td><b>Years</b></td>
                                </thead>
                                <tbody data-bind="foreach: reserves">
                                  <!-- ko if: years().length -->
                                  <tr>
                                  <!--
                                  <tr data-bind="if: years().length">
                                  -->
                                    <td data-bind="text: reserve_name"></td>
                                    <td data-bind="text: reserve_code"></td>
                                    <td data-bind="text: state"></td>
                                    <td data-bind='attr: {id: "#" + reserve_code + "-years-col"}'>
                                      <select id="m_sel" class="multiselect" multiple="multiple"
                                        data-bind="options: years,
                                        optionsText: 'year',
                                        optionsValue: 'year',
                                        selectedOptions: selected_years,
                                        maxHeight: 200,
                                        multiselect: true">
                                      </select>
                                      <!--
                                      <select id="m_sel" class="multiselect" multiple="multiple" data-bind='
                                          maxHeight: 200,
                                          multiselect: true
                                          '>
                                      </select>
                                      -->
                                    </td>
                                   </tr>
                                  <!-- /ko -->
                                </tbody>
                              </table>
                            </div>
                          </div>
                          <!--End reserves table row-->
                          <div class="row">
                            <div class="col-xs-12">
                              <button type="button" class="btn btn-default data_selection_complete_btn" data-bind="click: function(data) { $data.selection_complete_click($parents[0]) }">
                                <b>Selection Complete</b>
                              </button>
                            </div>
                          </div>
                        </div>
                        <!-- End reserves tab -->

                        <!-- Begin send info form tab -->
                        <div class="tab-pane fade in" id="send_receive" data-bind="with: find_tab_obj('send_receive')['send_receive'].view_model">
                          <div class="row">
                            <div class="col-xs-12">
                              <h3><b>Please fill in the following information to receive your data:</b></h3>
                            </div>
                          </div>
                          <div class="row">
                            <div class="col-xs-12">
                              <hr>
                            </div>
                          </div>
                          <div class="row">
                            <div class="col-xs-12">
                              We require a valid email address in order to deliver your data files.  In an effort to ensure data integrity and provide our users with authenticated data, the Centralized Data Management Office will contact you via email in the event of data correction with detailed information regarding the issue.  These corrections occur infrequently.  For statistical and accuracy purposes the Centralized Data Management Office tracks all users that download data from our website.  We will use this information to help develop and improve our online services and data delivery.  This information, including your email address, will not be shared with outside parties.
                            </div>
                          </div>
                          <div class="row">
                            <div class="col-xs-12">
                              <br>
                            </div>
                          </div>
                          <div class="row">
                            <div class="col-xs-12">
                              <!--
                              <form class="form-horizontal" id="use_data" role="form" data-bind="submit: sendForm">
                              -->
                              <form class="form-horizontal" id="use_data">
                                <div class="form-group">
                                  <div class="form-input-group">
                                    <label class="col-xs-2 control-label">First Name:</label>
                                    <div class="col-xs-3">
                                      <input data-bind="value: first_name" class="form-control" type="text" name="first_name"
                                             placeholder="Enter first name" data-error="Please enter a First Name" required>
                                      <div class="help-block with-errors"></div>
                                    </div>
                                  </div>
                                  <div class="form-input-group">
                                    <label class="col-xs-2 control-label">Last Name:</label>
                                    <div class="col-xs-3">
                                      <input data-bind="value: last_name" class="form-control" type="text" name="last_name"
                                             placeholder="Enter last name"  data-error="Please enter a Last Name" required>
                                      <div class="help-block with-errors"></div>
                                    </div>
                                  </div>
                                </div>
                                <div class="form-group">
                                  <div class="form-input-group">
                                    <label class="col-xs-2 control-label">
                                      Email:
                                    </label>
                                    <div class="col-xs-3">
                                      <input data-bind="value: email_addr" class="form-control" type="email" name="email_addr" placeholder="Enter email address" data-error="Please enter a valid email address" required>
                                      <div class="help-block with-errors"></div>
                                    </div>
                                  </div>
                                  <div class="form-input-group">
                                    <label class="col-xs-2 control-label">
                                      Email Confirm:
                                    </label>
                                    <div class="col-xs-3">
                                      <input data-bind="value: email_addr_validate" class="form-control" type="email" name="email_addr" placeholder="Enter email address" data-error="Please enter a valid email address" required>
                                      <div class="help-block with-errors"></div>
                                    </div>
                                  </div>
                                </div>
                                <div class="form-group">
                                  <div class="form-input-group">
                                    <label class="col-xs-2 control-label">
                                      Organization:
                                    </label>
                                    <div class="col-xs-3">
                                      <input data-bind="value: organization" class="form-control" type="text" name="organization" placeholder="Enter your organization" data-error="Please enter your organization" required>
                                      <div class="help-block with-errors"></div>
                                    </div>
                                  </div>
                                  <div class="form-input-group">
                                    <label class="col-xs-2 control-label">
                                      Occupation:
                                    </label>
                                    <div class="col-xs-3 selectContainer">
                                      <select data-bind="value: occupation" name="occupation" class="form-control" required>
                                        <option value="">Please select...</option>
                                        <option value="K-12 Student">K-12 Student</option>
                                        <option value="College Student">College Student</option>
                                        <option value="Graduate Student">Graduate Student</option>
                                        <option value="Educator/Teacher">Educator/Teacher</option>
                                        <option value="Researcher/Scientist">Researcher/Scientist</option>
                                        <option value="Coastal/Resource Manager">Coastal/Resource Manager</option>
                                        <option value="Federal Government">Federal Government</option>
                                        <option value="State Government">State Government</option>
                                        <option value="Local Government">Local Government</option>
                                        <option value="General Public">General Public</option>
                                        <option value="Private Sector">Private Sector</option>
                                        <option value="Non-profit Organization">Non-profit Organization</option>
                                        <option value="Other">Other</option>
                                      </select>
                                      <div class="help-block with-errors"></div>
                                    </div>
                                  </div>
                                </div>
                                <div class="form-group">
                                  <div class="form-input-group">
                                    <label class="col-xs-2 control-label">Purpose:</label>
                                    <div class="col-xs-3 selectContainer">
                                      <select data-bind="value: purpose" name="purpose" class="form-control" required>
                                        <option value="">Please select...</option>
                                        <option value="Research">Research</option>
                                        <option value="Class Project">Class Project</option>
                                        <option value="Data Synthesis">Data Synthesis</option>
                                        <option value="Education">Education</option>
                                        <option value="Consulting">Consulting</option>
                                        <option value="Management">Management</option>
                                        <option value="Curriculum Development">Curriculum Development</option>
                                        <option value="Other">Other</option>
                                      </select>
                                      <div class="help-block with-errors"></div>
                                    </div>
                                  </div>
                                  <div class="form-input-group">
                                    <label class="col-xs-2 control-label">NERRS Staff:</label>
                                    <div class="col-xs-3">
                                      <div>
                                        <label class="radio-inline">
                                            <input type="radio" name="staff" value="yes" required> Yes
                                        </label>
                                        <label class="radio-inline">
                                            <input type="radio" name="staff" value="no" required> No
                                        </label>
                                      </div>
                                    </div>
                                    <!-- This is just a placeholder to pad out the centering for this input -->
                                    <div class="col-xs-4"></div>
                                  </div>
                                </div>
                                <div class="form-group">
                                  <label class="col-xs-2 control-label" for="comments">Comments:</label>
                                  <div class="col-xs-8 col-centered">
                                    <textarea data-bind="value: comments_cleaned" name="comments" class="form-control" rows="3"></textarea>
                                  </div>
                                  <!-- This is just a placeholder to pad out the centering for this input -->
                                  <div class="col-xs-4 col-centered"></div>
                                </div>
                                <div class="form-group">
                                  <div class="col-xs-12 text-center">
                                    <button type="submit" class="btn btn-primary">Submit Request To CDMO</button>
                                  </div>
                                </div>
                              </form>
                            </div>
                          </div>
                        </div>
                        <!-- End send info forms tab -->
                      </div>
                    </div>
                    <div class="col-xs-1"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="right_col">
          <div class="bg_new_right"></div>
        </div>
      </div>
    </div>
    <!-- Start Help Modal -->
    <div class="modal fade" id="help_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title" id="myModalLabel">Help Page</h4>
          </div>
          <div class="modal-body">
            <span class="popup_body">
              Select the type of data you are interested in here.
              Reserves/years with available datasets will automatically populate in the next tab.
              If a Reserve collects more than one type of data, it will be available for selection
              under both options.
              <br>
              There are no Mangrove datasets available at this time.
              <br>
              Contact us at cdmowebmaster@baruch.sc.edu with any questions.
            </span>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    <!-- End Help Modal -->
    <!-- Start Ok/Cancel Modal -->
    <div class="modal fade" id="ok_cancel_modal" tabindex="-1" role="dialog" aria-labelledby="ok_cancel_modal_label" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
              Attention
          </div>
          <div class="modal-body">
              Your previous selections will be reset, press Cancel to go back.
          </div>
          <div class="modal-footer">
              <button id="ok_cancel_ok_btn" type="button" class="btn btn-ok" data-dismiss="modal">Ok</button>
              <button id="ok_cancel_cancel_btn" type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
          </div>
        </div>
      </div>
    </div>
    <!-- End Ok/Cancel Modal -->
    <!-- Start POST Modal -->
    <div id="message_popup" class="modal fade"  tabindex="-1" role="dialog" aria-labelledby="message_popup_modal_label" aria-hidden="true">>
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <!--
            <button type="button" class="close" data-dismiss="modal">
              <span aria-hidden="true">&times;</span>
              <span class="sr-only">Close</span>
            </button>
            -->
            <span data-bind="text: popup_title"></span>
          </div>
          <div class="modal-body">
            <span class="popup_body" data-bind="text: popup_message"></span>
          </div>
          <div class="modal-footer">
            <button id="message_popup_close_btn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          </div>
        </div><!-- /.modal-content -->
      </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <!-- End POST Modal -->

    <!-- Placed at the end of the document so the pages load faster -->

    <script>
      function vegetation_app()
      {
        var self = this;

        self.test_data;
        self.viewModel = null;
        self.initialize = function()
        {
          self.viewModel = new view_model();
          self.viewModel.initialize(self.test_data);
          ko.applyBindings(self.viewModel);

          $.ajax({
            url: "reserves_vegetation_data.txt",
            dataType: "json",
            success: self.received_data
          });

        };
        self.received_data = function(json_data, code, jqXHR)
        {
          var view_obj = self.viewModel.find_tab_obj('reserve');
          view_obj['reserve'].view_model.process_data(json_data);
        };

        $( document ).ready(function()
        {
          //Pull in the menu and the footer from the HTML files. We do this to try and avoid getting mired in CF crap.
          $("#cdmo_menu_div").load("../menus/index.html");
          $("#cdmo_footer").load("../bottom.cfm");

          $('#veg_tabs a[href="#dataset_type"]').tab('show');
          //Force the popovers to work on a hover.
          $('[data-toggle="popover"]').popover({
                  trigger: 'click',
                  placement: 'top'
                });


        });

        return(self);
      }
      app = vegetation_app();
      app.initialize();

    </script>
            </div>

            <cfinclude template="/core-components/footer.cfm">
        </div>
  </body>
</html>
