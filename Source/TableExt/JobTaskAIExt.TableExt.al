namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;
using System.IO;
using System.Text;
using Microsoft.Projects.Project.Planning;

tableextension 60102 "Job Task AI Ext" extends "Job Task"
{
    /// <summary>
    /// Get the JSON representation of the record.
    /// </summary>
    /// <returns></returns>
    procedure AsJson() JobJsonObject: JsonObject
    var
        JsonUtility: Codeunit "Json Utilities";
        RecRef: RecordRef;
    begin

        RecRef.GetTable(Rec);
        JobJsonObject := JsonUtility.GetJsonFromRecord(RecRef);

        JobJsonObject.Add('JobPlanningLines', GetJobPlannignLinesAsJsonArray());

        exit(JobJsonObject);

    end;

    /// <summary>
    /// Get the JSON representation of the Job Planning Lines as a JsonArray.
    /// </summary>
    /// <returns></returns>
    local procedure GetJobPlannignLinesAsJsonArray() JobTaskJsonArray: JsonArray
    var
        JobPlannigLine: Record "Job Planning Line";
    begin
        JobPlannigLine.SetRange("Job No.", Rec."Job Task No.");
        JobPlannigLine.SetRange("Job Task No.", Rec."Job Task No.");
        if JobPlannigLine.FindSet() then
            repeat
                JobTaskJsonArray.Add(JobPlannigLine.AsJson());
            until JobPlannigLine.Next() = 0;

    end;
}
