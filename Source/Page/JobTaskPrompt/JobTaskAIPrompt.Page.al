namespace ProjectAI.ProjectAI;
using ProjectAI.Utilities;
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Planning;

page 60104 "Job Task AI Prompt"
{
    PageType = PromptDialog;
    Extensible = false; //Obbligatorio

    ApplicationArea = All;
    UsageCategory = Administration;

    PromptMode = Prompt; //Default
    //PromptMode = Content; //attiva la generazione dell'output dell'interazione con Copilot
    //PromptMode = Generate; //mostra l'output dell'interazione com Copilot


    IsPreview = true; //true = anteprima della funzionalità (indica all'utente che l'esperienza è sperimentale...)

    layout
    {
        /// <summary>
        /// L'area Prompt è l'input per il copilota e accetta qualsiasi controllo, ad eccezione dei comandi di un Repeater
        /// Questa è la sezione di input che accetta l'input dell'utente per generare il contenuto.
        /// </summary>
        area(Prompt)
        {
            /// <summary>
            /// L'utente deve inserire cosa vuole che venga fatto sulla riga selezionata
            /// </summary>
            field(ProjectDescriptionField; InputProjectDescription)
            {
                ShowCaption = false;
                MultiLine = true;
                InstructionalText = 'You can specify characteristics in order to search for the most suitable items.';
            }
        }

        /// <summary>
        /// L'area Contenuto è l'uscita del copilota e accetta qualsiasi controllo, ad eccezione dei comandi del Repeater
        /// Questa è la sezione di output che visualizza il contenuto generato
        /// </summary>
        // area(Content)
        // {
        //     part(ProjectAIResponseSubpage; "Project AI Response")
        //     {
        //         Caption = 'Job Task Lines';
        //         ShowFilter = false;
        //         Editable = true;
        //         Enabled = true;
        //     }
        // }

    }

    actions
    {
        /// <summary>
        /// L'area PromptGuide rappresenta un elenco di "guide" predefinite per i prompt di testo, 
        /// gli utenti possono selezionare per utilizzarle come input per generare contenuti, 
        /// invece di creare il proprio prompt da zero. Il menu della guida al prompt viene reso nel client Web 
        /// solo quando il PromptMode della pagina PromptDialog è impostato su Prompt.
        /// </summary> 
        area(PromptGuide)
        {
            action(SearchChair)
            {
                ApplicationArea = All;
                Caption = 'Search chairs blue';

                trigger OnAction()
                var
                    PromptSuggestionTxt: Label 'Look for the most modern and comfortable chairs in blue.';
                begin
                    InputProjectDescription := PromptSuggestionTxt;
                end;
            }

            action(SearchTable)
            {
                ApplicationArea = All;
                Caption = 'Search a big table';

                trigger OnAction()
                var
                    PromptSuggestionTxt: Label 'Look for a large, modern table.';
                begin
                    InputProjectDescription := PromptSuggestionTxt;
                end;
            }
        }

        /// <summary>
        /// L'area SystemActions consente di definire solo un insieme fisso di azioni chiamate azioni di sistema, 
        /// che sono supportate solo da questo tipo di pagina. Le azioni di sistema sono Generate, Regenerate, Attach, Ok e Cancel.
        /// </summary> 
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
                ToolTip = 'Extend the details of the selected task.';

                trigger OnAction()
                begin
                    RunGeneration(TempCurrentJobTask);
                end;
            }
            systemaction(OK)
            {
                Caption = 'Keep it';
                ToolTip = 'Apply the changes suggested by Copilot.';
            }
            systemaction(Cancel)
            {
                Caption = 'Discard it';
                ToolTip = 'Discard the changes suggested by Copilot.';
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                ToolTip = 'Regenerate the Project proposed by Dynamics 365 Copilot.';

                trigger OnAction()
                begin
                    RunGeneration(TempCurrentJobTask);
                end;
            }
        }
    }

    // procedure SetJob(Job: Record Job)
    // begin
    //     //Server solo per avere le info
    //     TempCurrentJob.TransferFields(Job);
    // end;

    local procedure RunGeneration(TempJobTask: Record "Job Task" temporary)
    var
        ProjectTaskUtilities: Codeunit "Search Item Utilities";
        ProgressDialog: Dialog;
    begin
        ProgressDialog.Open(GeneratingTextDialogTxt);
        ProjectTaskUtilities.SearchItemsByTopic(TempJobTask, InputProjectDescription);

        // CurrPage.ProjectAIResponseSubpage.Page.ReadFrom(TempJobTask);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // if CloseAction = CloseAction::OK then
        //     CurrPage.ProjectAIResponseSubpage.Page.WriteTo(TempResultJobTask);
    end;

    procedure WriteTo(var TempJobTaskToWrite: Record "Job Task" temporary; var TempJobPlanningLineToWrite: Record "Job Planning Line" temporary)
    begin

        // TempResultJobTask.Reset();
        // if TempResultJobTask.FindSet() then
        //     repeat

        //         TempJobTaskToWrite.Init();
        //         TempJobTaskToWrite.TransferFields(TempResultJobTask);
        //         TempJobTaskToWrite.Insert(false);

        //     until TempResultJobTask.Next() = 0;

        // TempJobPlanningLine.Reset();
        // if TempJobPlanningLine.FindSet() then
        //     repeat

        //         TempJobPlanningLineToWrite.Init();
        //         TempJobPlanningLineToWrite.TransferFields(TempJobPlanningLine);
        //         TempJobPlanningLineToWrite.Insert(false);

        //     until TempJobPlanningLine.Next() = 0;
    end;

    procedure SetJobTask(JobTask: Record "Job Task")
    begin
        TempCurrentJobTask.Init();
        TempCurrentJobTask.TransferFields(JobTask);
    end;

    //Variabili
    var
        TempCurrentJobTask: Record "Job Task" temporary;
        InputProjectDescription: Text;
        GeneratingTextDialogTxt: Label 'Generating with Copilot...';

}
