namespace ProjectAI.ProjectAI;
using Microsoft.Projects.Project.Job;

page 60101 "Job AI Response"
{
    ApplicationArea = All;
    Caption = 'Project AI Response';
    PageType = ListPart;
    SourceTable = "Job Task";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                IndentationControls = Description;
                ShowCaption = false;
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic, Suite, Jobs;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the number of the related project.';
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = Basic, Suite, Jobs;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the number of the related project task.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite, Jobs;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies a description of the project task. You can enter anything that is meaningful in describing the task. The description is copied and used in descriptions on the project planning line.';
                }
                field("Job Task Type"; Rec."Job Task Type")
                {
                    ApplicationArea = Basic, Suite, Jobs;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this. Choose the field to select one of the following five options:';
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies an interval or a list of project task numbers.';
                    Visible = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleIsStrong := Rec."Job Task Type" <> "Job Task Type"::Posting;
    end;

    procedure ReadFrom(var TempJobTask: Record "Job Task" temporary)
    begin

        TempJobTask.Reset();
        if TempJobTask.FindSet() then
            repeat
                Rec.Copy(TempJobTask, false);
                Rec.Insert(false);
            until TempJobTask.Next() = 0;

        CurrPage.Update(false);
    end;

    procedure WriteTo(var TempJobTask: Record "Job Task" temporary)
    begin

        TempJobTask.Reset();
        TempJobTask.DeleteAll(false);

        Rec.Reset();
        if Rec.FindSet() then
            repeat

                TempJobTask.Init();
                TempJobTask.TransferFields(Rec);
                TempJobTask.Insert(false);

            until Rec.Next() = 0;
    end;

    var
        StyleIsStrong: Boolean;
}
