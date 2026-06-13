# rap-salesorders

An **abapGit-format SAP RAP** (ABAP RESTful Application Programming Model) source
repository implementing a **managed** business object for the **SalesOrders** domain.

> **Important:** RAP runs *inside* an ABAP system (SAP S/4HANA or the SAP BTP ABAP
> environment / "Steampunk"). These are **source artifacts** in abapGit layout, meant
> to be cloned into an ABAP system via [abapGit](https://abapgit.org) and then
> **activated** there. They cannot be compiled or run on a local workstation, and the
> object metadata has not been round-tripped against a live system, so validate on
> import.

## Business object
A managed RAP BO with draft-free transactional behavior, optimistic concurrency
(ETag on `LocalLastChangedAt`), a determination, a validation, and a `submit` action.

| Object | Name | Type |
|--------|------|------|
| Table | `ZTSALESORDER` | Transparent table (persistence) |
| Interface view | `ZI_SALESORDER` | CDS root view entity |
| Projection view | `ZC_SALESORDER` | CDS projection (`transactional_query`) |
| Behavior definition | `ZI_SALESORDER` | `managed`, base |
| Behavior definition | `ZC_SALESORDER` | `projection` |
| Behavior pool | `ZBP_SALESORDER` | ABAP class (handlers) |
| Service definition | `Z_SALESORDER_SRVD` | exposes `ZC_SALESORDER` |
| Service binding | `Z_SALESORDER_O4` | OData V4 (UI) |

## Behavior
- `create` / `update` / `delete`
- `submit` action -> sets `Status = 'Submitted'`, returns `$self`
- determination `setInitialStatus` -> defaults `Status = 'Open'` on create
- validation `validateAmount` -> rejects negative `Amount`

## Import
1. In your ABAP system, open transaction/app for **abapGit** (or Eclipse ADT with the
   abapGit plugin).
2. Clone this repository into a package (`$TMP` for trial, or a transportable package).
3. Pull and **activate** all objects.
4. Publish the service binding `Z_SALESORDER_O4` and preview the Fiori Elements app.

## Layout
```
.abapgit.xml          # abapGit repo descriptor (STARTING_FOLDER=/src/)
src/
  ztsalesorder.tabl.xml
  zi_salesorder.ddls.asddls / .ddls.xml
  zc_salesorder.ddls.asddls / .ddls.xml
  zi_salesorder.bdef.asbdef / .bdef.xml
  zc_salesorder.bdef.asbdef / .bdef.xml
  zbp_salesorder.clas.abap / .clas.xml
  z_salesorder_srvd.srvd.assrvd / .srvd.xml
  z_salesorder_o4.srvb.xml
```

> Generated as part of a batch of SAP sample apps. Domain: SalesOrders.