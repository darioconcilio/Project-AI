namespace ProjectAI.ProjectAI;

using System.AI;
using ProjectAI.Utilities;
using Microsoft.Projects.Project.Job;
using Microsoft.Inventory.Item.Attribute;
using Microsoft.Inventory.Item;

codeunit 60107 "Search Item by Func. Call" implements "AOAI Function"
{
    var
        JobTask: Record "Job Task";
        ProjectTaskUtilities: Codeunit "Search Item Utilities";

    procedure GetPrompt(): JsonObject
    var
        Prompt: JsonObject;
        PromptText: Text;
    begin

        //TODO Creare una funzione parametrizzabile per generare questo prompt in formato JSON
        PromptText := '{' +
            '"type": "function",' +
            '"function":  {' +
                '"name": "search_items",' +
                '"description": "It searches for the articles that most closely match the criteria indicated by the user.",' +
                '"parameters": {' +
                    '"type": "object",' +
                    '"properties": {' +
                        '"jobNo": {' +
                            '"type": "string",' +
                            '"description": "The unique identifier of the job to be reference"' +
                        '},' +
                        '"jobTaskNo": {' +
                            '"type": "string",' +
                            '"description": "The unique identifier of the task to be broken down"' +
                        '},' +
                        '"color": {' +
                            '"type": "string",' +
                            '"description": "The colour to be used when searching for items"' +
                        '}' +
                    '},' +
                    '"required": ["jobNo", "jobTaskNo", "color"]' +
                '}' +
            '}' +
        '}';

        Prompt.ReadFrom(PromptText);
        exit(Prompt);
    end;

    procedure Execute(Arguments: JsonObject): Variant
    var
        TempItemFiltered: Record Item temporary;
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        ItemAttributeManagement: Codeunit "Item Attribute Management";
        Color: Text;
        Token: JsonToken;
        JobNo: Code[20];
        JobTaskNo: Code[20];
        Result: JsonArray;
        ArributeIdTxt: Label 'Colore', Locked = true;
    begin
        if not Arguments.Get('jobNo', Token) and not Token.IsValue then
            Error('Missing required parameter: jobNo');
        JobNo := Token.AsValue().AsCode();

        if not Arguments.Get('jobTaskNo', Token) and not Token.IsValue then
            Error('Missing required parameter: jobTaskNo');
        JobTaskNo := Token.AsValue().AsCode();

        if not Arguments.Get('color', Token) and not Token.IsValue then
            Error('Missing required parameter: color');
        Color := Token.AsValue().AsText();

        if not JobTask.Get(JobNo, JobTaskNo) then
            Error('Task not found. Job No.: %1, Job Task No.: %2', JobNo, JobTaskNo);

        //Prepara il criterio di ricerca per gli articoli
        TempFilterItemAttributesBuffer.Init();
        TempFilterItemAttributesBuffer.Attribute := ArributeIdTxt;
        TempFilterItemAttributesBuffer.Value := Format(Color, 250).Trim();
        TempFilterItemAttributesBuffer.Insert();

        //Cerca gli articoli tramite gli attributi
        ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer, TempItemFiltered);

        if TempItemFiltered.FindSet() then
            repeat

                //Aggiungo gli articoli alla lista di risposta convertendoli in JSON
                Result.Add(TempItemFiltered.AsJson());

            until TempItemFiltered.Next() = 0;

        exit(Result);
    end;

    procedure GetName(): Text
    begin
        exit('search_items');
    end;
}