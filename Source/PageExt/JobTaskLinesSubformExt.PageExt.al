namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;

pageextension 60100 "Job Task Lines Subform Ext." extends "Job Task Lines Subform"
{
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
        TempJobTask.DeleteAll();

        Rec.Reset();
        if Rec.FindSet() then
            repeat

                TempJobTask.Init();
                TempJobTask.TransferFields(Rec);
                TempJobTask.Insert(false);

            until Rec.Next() = 0;
    end;
}
