namespace ProjectAI.Copilot;

using System.AI;
using ProjectAI.Capabilities;
using ProjectAI.ProjectAI;
using ProjectAI.Enums;

codeunit 60102 "Toolkit Copilot"
{
    var
        AOAIChatMessages: Codeunit "AOAI Chat Messages";

    procedure Chat(SystemPrompt: Text; ChatUserPrompt: Text) Result: Text
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";

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
        AOAIChatCompletionParams.SetMaxTokens(9000); //Numero massimo di token in risposta
        AOAIChatCompletionParams.SetJsonMode(true); //Risposta in formato json

        //Numero compreso tra -2,0 e 2,0. I valori positivi penalizzano i nuovi token in base alla loro frequenza attuale nel testo, 
        //riducendo la probabilità che il modello ripeta la stessa riga alla lettera.
        AOAIChatCompletionParams.SetFrequencyPenalty(0);

        //Numero compreso tra -2,0 e 2,0. I valori positivi penalizzano i nuovi token a seconda che siano già presenti nel testo, 
        //aumentando la probabilità che il modello tratti nuovi argomenti.
        AOAIChatCompletionParams.SetPresencePenalty(0);

        //Imposta il numero massimo di messaggi da inviare come cronologia dei messaggi
        AOAIChatCompletionParams.SetMaxHistory(0);

        //Imposta la temperatura di campionamento da utilizzare, compresa tra 0 e 2. Una temperatura più elevata aumenta 
        //la probabilità che il token successivo più probabile non venga selezionato. Quando si richiedono dati strutturati, 
        //impostare la temperatura su 0. Per il parlato umano, 0,7 è un valore tipico.
        AOAIChatCompletionParams.SetTemperature(0);

        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::JobCopilotAI);

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

    procedure AddFunctionCall(ToolChoiseName: Text; FunctionCall: Interface "AOAI Function")
    var
        ToolChoiceTxt: Label '{"type": "function","function": {"name": "%1"}}', Locked = true;
    begin
        // Add tool
        AOAIChatMessages.AddTool(FunctionCall);
        // Set tool choice to added tool
        AOAIChatMessages.SetToolChoice(StrSubstNo(ToolChoiceTxt, ToolChoiseName));
    end;
}
