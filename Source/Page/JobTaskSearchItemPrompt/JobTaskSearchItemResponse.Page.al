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
}
