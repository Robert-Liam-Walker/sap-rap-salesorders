CLASS ZBP_SALESORDER DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF ZI_SALESORDER.
ENDCLASS.

CLASS ZBP_SALESORDER IMPLEMENTATION.
ENDCLASS.

CLASS lhc_SalesOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      setInitialStatus FOR DETERMINE ON MODIFY
        IMPORTING keys FOR SalesOrder~setInitialStatus,
      validateAmount FOR VALIDATE ON SAVE
        IMPORTING keys FOR SalesOrder~validateAmount,
      submit FOR MODIFY
        IMPORTING keys FOR ACTION SalesOrder~submit RESULT result.
ENDCLASS.

CLASS lhc_SalesOrder IMPLEMENTATION.

  METHOD setInitialStatus.
    READ ENTITIES OF ZI_SALESORDER IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_salesorder).

    DELETE lt_salesorder WHERE Status IS NOT INITIAL.
    CHECK lt_salesorder IS NOT INITIAL.

    MODIFY ENTITIES OF ZI_SALESORDER IN LOCAL MODE
      ENTITY SalesOrder
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR ls IN lt_salesorder
                      ( %tky   = ls-%tky
                        Status = 'Open' ) ).
  ENDMETHOD.

  METHOD validateAmount.
    READ ENTITIES OF ZI_SALESORDER IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( Amount )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_salesorder).

    LOOP AT lt_salesorder INTO DATA(ls_salesorder).
      IF ls_salesorder-Amount < 0.
        APPEND VALUE #( %tky = ls_salesorder-%tky ) TO failed-salesorder.
        APPEND VALUE #( %tky = ls_salesorder-%tky
                        %msg = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = 'Amount must not be negative' )
                        %element-Amount = if_abap_behv=>mk-on ) TO reported-salesorder.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD submit.
    MODIFY ENTITIES OF ZI_SALESORDER IN LOCAL MODE
      ENTITY SalesOrder
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys
                      ( %tky   = key-%tky
                        Status = 'Submitted' ) ).

    READ ENTITIES OF ZI_SALESORDER IN LOCAL MODE
      ENTITY SalesOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_salesorder).

    result = VALUE #( FOR ls IN lt_salesorder
                      ( %tky   = ls-%tky
                        %param = ls ) ).
  ENDMETHOD.

ENDCLASS.