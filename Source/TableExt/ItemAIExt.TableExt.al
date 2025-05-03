namespace ProjectAI.ProjectAI;

using Microsoft.Inventory.Item;

tableextension 60104 "Item AI Ext." extends Item
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

        exit(JobJsonObject);

    end;
}
