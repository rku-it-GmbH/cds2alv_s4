"! This interface contains event handlers for the selection screen events
"! that are implemented in the reports generated by the default generation strategy.
"! On all of these events the registered report extensions are also called.
INTERFACE zif_cds_alv_report_controller PUBLIC.
  "! event INITIALIZATION <br/>
  "! default:
  "! <br/> - GUI title is set
  "! <br/> - extensions are called
  METHODS initialization.

  "! event AT SELECTION-SCREEN OUTPUT <br/>
  "! default:
  "! <br/> - selection restrictions are applied
  "! <br/> - selection texts are modified
  "! <br/> - input readiness of default parameters is set
  "! <br/> - extensions are called
  METHODS at_selection_screen_output.

  "! event AT SELECTION-SCREEN <br/>
  "! default:
  "! <br/> - extensions are called to handle the user command
  "! @parameter i_ucomm | user command
  METHODS at_selection_screen
    IMPORTING i_ucomm TYPE syucomm.

  "! event AT SELECTION-SCREEN ON VALUE-REQUEST <br/>
  "! default:
  "! <br/> - standard value help for layout and CDS elements (provided by Consumption.valueHelpDefinition)
  "! <br/> - extensions are called for additional value help
  "! @parameter i_sel_name | dynpro field the value help is called for
  "! @parameter c_value    | value of the dynpro field
  METHODS at_value_request
    IMPORTING i_sel_name TYPE rsscr_name
    CHANGING  c_value    TYPE any.

  "! event AT SELECTION-SCREEN ON HELP-REQUEST <br/>
  "! default:
  "! <br/> - extensions are called for additional help
  "! @parameter i_sel_name | dynpro field the help is called for
  METHODS at_help_request
    IMPORTING i_sel_name TYPE rsscr_name.

  "! event START-OF-SELECTION <br/>
  "! default:
  "! <br/> - selection via SADL framework
  "! <br/> - display in ALV grid
  "! <br/> - extensions are called for alternative selection
  "! <br/> - extensions are called for alternative display
  "! @parameter i_selection       | alternative selection to be used
  "! @parameter i_display         | alternative display to be used
  "! @parameter i_forall          | if true, a FORALL table from ABAP memory is used for the selection
  "! @parameter i_memory_id       | memory ID which stores the FORALL table
  "! @parameter i_in_split_screen | if true, the selection screen will be displayed above the ALV grid
  METHODS start_of_selection
    IMPORTING i_selection       TYPE zcds_alv_report_extension_name OPTIONAL
              i_display         TYPE zcds_alv_report_extension_name OPTIONAL
              i_forall          TYPE abap_bool                      DEFAULT abap_false
              i_memory_id       TYPE memory_id                      OPTIONAL
              i_in_split_screen TYPE abap_bool                      DEFAULT abap_false.
ENDINTERFACE.
