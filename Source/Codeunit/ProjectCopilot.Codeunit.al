namespace ProjectAI.Copilot;

using System.AI;
using ProjectAI.Capabilities;
using ProjectAI.Enums;

codeunit 60102 "Project Copilot"
{
    procedure Chat(SystemPrompt: Text; ChatUserPrompt: Text) Result: Text
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        AOAIToken: Codeunit "AOAI Token";

        AISettings: Codeunit "AI Settings";

        Endpoint: Text;
        Deployment: Text;
        ApiKey: SecretText;

        MaxModelRequestTokensErr: Label 'Token limit exceeded';

        ErrorInfo: ErrorInfo;
        SystemTokens: Integer;

    //TraceSystemPromptLbl: Label 'System Prompt [%1]: %2', Comment = '%1 = length of prompt, %2 = System Prompt';
    begin

        //Message(StrSubstNo(TraceSystemPromptLbl, StrLen(SystemPrompt), SystemPrompt));

        Endpoint := AISettings.GetEndpointUrl();
        Deployment := AISettings.GetDeployment();
        ApiKey := AISettings.GetSecretKey();

        //Impostazione del servizio Open AI
        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions",
                                     Endpoint,
                                     Deployment,
                                     ApiKey);

        //Numero massimo di token da utilizzare
        AOAIChatCompletionParams.SetMaxTokens(9000);
        AOAIChatCompletionParams.SetJsonMode(true);

        //Livello di "intelligenza"
        AOAIChatCompletionParams.SetTemperature(0.7);
        //AOAIChatCompletionParams.SetJsonMode(true);

        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::ProjectAI);

        //Esecuzione della chiamata
        SystemTokens := 630;
        if SystemPrompt <> '' then
            SystemTokens := AOAIToken.GetGPT4TokenCount(SystemPrompt);

        if SystemTokens + AOAIToken.GetGPT4TokenCount(ChatUserPrompt) <= MaxModelRequestTokens() then begin

            //Preparazione del contesto
            if SystemPrompt <> '' then
                AOAIChatMessages.SetPrimarySystemMessage(SystemPrompt);

            //Richiesta dell'utente
            AOAIChatMessages.AddUserMessage(ChatUserPrompt);

            AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);
            if AOAIOperationResponse.IsSuccess() then
                Result := AOAIChatMessages.GetLastMessage()
            else begin
                ErrorInfo.ErrorType(ErrorType::Client);
                ErrorInfo.Message(AOAIOperationResponse.GetError());
                Error(ErrorInfo);
            end;

            //exit(Result);
        end else
            Error(MaxModelRequestTokensErr);

        //Gestione dell'esito
        /*if AOAIOperationResponse.IsSuccess() then
            Result := AOAIChatMessages.GetLastMessage()
        else
            Error(AOAIOperationResponse.GetError());*/

        //exit(Result);
    end;

    local procedure MaxModelRequestTokens(): Integer
    begin
        exit(128000)
    end;
}
