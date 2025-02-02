namespace ProjectAI.ProjectAI;

using Microsoft.Inventory.Item;

query 60100 "Item API"
{
    APIGroup = 'inventoryGroup';
    APIPublisher = 'vitaDaSviluppatore';
    APIVersion = 'v1.0';
    EntityName = 'item';
    EntitySetName = 'items';
    QueryType = API;

    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(item; Item)
        {
            column(no; "No.")
            {
            }
            column(description; Description)
            {
            }
            column("type"; "Type")
            {
            }
            column(inventoryPostingGroup; "Inventory Posting Group")
            {
            }
            column(itemDiscGroup; "Item Disc. Group")
            {
            }
            column(costingMethod; "Costing Method")
            {
            }

            dataitem(itemUnitOfMeasure; "Item Unit of Measure")
            {
                DataItemLink = "Item No." = item."No.";
                SqlJoinType = LeftOuterJoin;

                column(umCode; Code)
                {

                }
                column(qtyPerUnitOfMeasure; "Qty. per Unit of Measure")
                {

                }
            }
        }
    }

}
