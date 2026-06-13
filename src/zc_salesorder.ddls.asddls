@EndUserText.label: 'SalesOrders - projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_SALESORDER
  provider contract transactional_query
  as projection on ZI_SALESORDER
{
  key SalesOrderUuid,
      @Search.defaultSearchElement: true
      SalesOrderId,
      @Search.defaultSearchElement: true
      Title,
      Status,
      Amount,
      CurrencyCode,
      SalesOrderDate,
      Description,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}