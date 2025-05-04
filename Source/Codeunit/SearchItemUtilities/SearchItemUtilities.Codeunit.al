namespace ProjectAI.Utilities;
using ProjectAI.Copilot;
using ProjectAI.ProjectAI;
using Microsoft.Projects.Project.Job;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Project.Planning;
using Microsoft.Projects.Resources.Resource;
using Microsoft.HumanResources.Employee;

codeunit 60106 "Search Item Utilities"
{
    var
        ToolkitCopilot: Codeunit "Toolkit Copilot";
        Response: Text;


    local procedure GetSystemPrompt() SystemPrompt: Text
    begin
        SystemPrompt := 'You are a project management assistant. ' +
                        'You will help the user to serach better items to insert for budget. ' +
                        'You will have to provide a list of items that comply with the criteria required by the user, specifically colour. ' +
                        'Your responses should be clear and concise. ' +
                        'Important! Use for response only json format';
    end;

    procedure SearchItemsByTopic(var JobTask: Record "Job Task"; UserPrompt: Text; TempItemsFound: Record Item temporary)
    var
        JobTaskFunctionCall: Codeunit "Search Item by Func. Call";
        //Farà parte del prompt, quindi nono va tradotto
        ReferenceLbl: Label 'Reference: Job No: %1, Job Task No: %2', Comment = '%1 = Job No, %2 = Job Task No', Locked = true;
        ItemsJA: JsonArray;
        ItemJT: JsonToken;
        ItemJO: JsonObject;
    begin

        //Init output
        TempItemsFound.Reset();
        TempItemsFound.DeleteAll();

        //Attivazione delle function call
        ToolkitCopilot.AddFunctionCall('search_items', JobTaskFunctionCall);

        //Aggiunta dei riferimenti necessari alla function call
        UserPrompt += StrSubstNo(ReferenceLbl, JobTask."Job No.", JobTask."Job Task No.");

        //Chiamama al nostro tookit copilot
        Response := ToolkitCopilot.Chat(GetSystemPrompt(), UserPrompt);

        ItemsJA.ReadFrom(Response);

        foreach ItemJT in ItemsJA do begin

            ItemJO := ItemJT.AsObject();

            TempItemsFound.Init();
            Evaluate(TempItemsFound."No.", ItemJO.GetText('no'));
            Evaluate(TempItemsFound."Description", ItemJO.GetText('description'));
            TempItemsFound.Insert();

        end;
    end;

}
