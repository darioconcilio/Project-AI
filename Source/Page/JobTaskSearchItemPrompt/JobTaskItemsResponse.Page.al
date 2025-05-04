namespace ProjectAI.ProjectAI;

using Microsoft.Inventory.Item;

page 60105 "Job Task Items Response"
{
    SourceTable = Item;
    SourceTableTemporary = true;

    ApplicationArea = All;
    Caption = 'Job Task Items Response';

    PageType = ListPart;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite, Jobs;
                    Style = Strong;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite, Jobs;
                    Style = Strong;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    procedure ReadFrom(var TempItem: Record Item temporary)
    begin

        TempItem.Reset();
        if TempItem.FindSet() then
            repeat
                Rec.Copy(TempItem, false);
                Rec.Insert(false);
            until TempItem.Next() = 0;

        CurrPage.Update(false);
    end;

    procedure WriteTo(var TempItem: Record Item temporary)
    begin

        TempItem.Reset();
        TempItem.DeleteAll(false);

        Rec.Reset();
        if Rec.FindSet() then
            repeat

                TempItem.Init();
                TempItem.TransferFields(Rec);
                TempItem.Insert(false);

            until Rec.Next() = 0;
    end;
}
