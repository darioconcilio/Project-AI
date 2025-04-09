namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Job;

tableextension 60101 "Job AI Ext" extends Job
{
    /// <summary>
    /// Get the JSON representation of the record.
    /// </summary>
    /// <returns></returns>
    procedure GetRecordAsJson() JobJsonObject: JsonObject
    var

        JsonUtility: Codeunit "Json Utilities";
        RecRef: RecordRef;
    begin

        RecRef.GetTable(Rec);
        JobJsonObject := JsonUtility.GetJsonFromRecord(RecRef);

        JobJsonObject.Add('JobTasks', GetJobTasksAsJsonArray());

        exit(JobJsonObject);

    end;

    /// <summary>
    /// Get the JSON representation of the Job Tasks as a JsonArray.
    /// </summary>
    /// <returns></returns>
    local procedure GetJobTasksAsJsonArray() JobTaskJsonArray: JsonArray
    var
        JobTask: Record "Job Task";
    begin
        JobTask.SetRange("Job No.", Rec."No.");
        if JobTask.FindSet() then
            repeat
                JobTaskJsonArray.Add(JobTask.GetRecordAsJson());
            until JobTask.Next() = 0;

    end;
}
