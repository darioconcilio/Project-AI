namespace ProjectAI.ProjectAI;

using Microsoft.Projects.Project.Planning;

tableextension 60103 "Job Planning Line AI Ext" extends "Job Planning Line"
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

        exit(JobJsonObject);

    end;
}
