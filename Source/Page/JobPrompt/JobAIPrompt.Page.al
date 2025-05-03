namespace ProjectAI.ProjectAI;
using ProjectAI.Utilities;
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Planning;

page 60100 "Job AI Prompt"
{
    PageType = PromptDialog;
    Extensible = false; //Obbligatorio

    ApplicationArea = All;
    UsageCategory = Administration;

    PromptMode = Prompt; //Default
    //PromptMode = Content; //attiva la generazione dell'output dell'interazione con Copilot
    //PromptMode = Generate; //mostra l'output dell'interazione con Copilot


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
            /// L'utente deve inserire l'intento del progetto
            /// </summary>
            field(ProjectDescriptionField; InputProjectDescription)
            {
                ShowCaption = false;
                MultiLine = true;
                InstructionalText = 'Describe the project you want to create with Copilot';
            }
        }

        /// <summary>
        /// L'area Contenuto è l'uscita del copilota e accetta qualsiasi controllo, ad eccezione dei comandi del Repeater
        /// Questa è la sezione di output che visualizza il contenuto generato
        /// </summary>
        area(Content)
        {
            part(ProjectAIResponseSubpage; "Job AI Response")
            {
                Caption = 'Job Task Lines';
                ShowFilter = false;
                Editable = true;
                Enabled = true;
            }
        }

        /// <summary>
        /// L'area PromptOptions è l'area delle opzioni di input e accetta solo campi di Option
        /// </summary>
        area(PromptOptions)
        {
            field(SimulationBudget; SimulationBudget)
            {
                Caption = 'Simulation Budget';
                ToolTip = 'Specifies if you want taht Copilot simulates budget for job tasks.';
            }
        }


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
            action(PrepareProjectTasks)
            {
                ApplicationArea = All;
                Caption = 'Create a project';

                trigger OnAction()
                var
                    PromptSuggestionTxt: Label 'Create project about [topic] for [result], I need to create all phases of process';
                begin
                    InputProjectDescription := PromptSuggestionTxt;
                end;
            }

            // Group of actions

            group(Examples)
            {
                action(Gardening)
                {
                    ApplicationArea = All;
                    Caption = 'Gardening software';

                    trigger OnAction()
                    var
                        PromptSuggestionTxt: Label 'Create a plan for the design of a garden, it must also have a larder of all the native plants I can use in Europe. I am not familiar with the sector, so I will have to conduct interviews with specialists in the field';
                    begin
                        InputProjectDescription := PromptSuggestionTxt;
                    end;
                }

                action(RentAuto)
                {
                    ApplicationArea = All;
                    Caption = 'Car rental software';

                    trigger OnAction()
                    var
                        PromptSuggestionTxt: Label 'I have to develop a software for the management of a car rental, I need customer support to understand the dynamics and criticalities of the sector';
                    begin
                        InputProjectDescription := PromptSuggestionTxt;
                    end;
                }
            }

            action(OrganizeWorkshop)
            {
                ApplicationArea = All;
                Caption = 'Organize a workshop';

                trigger OnAction()
                var
                    PromptSuggestionTxt: Label 'I have to organise a business event, I have to set up all the preparatory stages, those during the event and after the event to get potential clients interested in my services';
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
                ToolTip = 'Generate project structure with Dynamics 365 Copilot.';

                trigger OnAction()
                begin
                    RunGeneration();
                end;
            }
            systemaction(OK)
            {
                Caption = 'Keep it';
                ToolTip = 'Save the Project proposed by Dynamics 365 Copilot.';
            }
            systemaction(Cancel)
            {
                Caption = 'Discard it';
                ToolTip = 'Discard the Project proposed by Dynamics 365 Copilot.';
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                ToolTip = 'Regenerate the Project proposed by Dynamics 365 Copilot.';

                trigger OnAction()
                begin
                    RunGeneration();
                end;
            }
        }

    }

    procedure SetJob(Job: Record Job)
    begin
        //Server solo per avere le info
        TempCurrentJob.TransferFields(Job);
    end;

    local procedure RunGeneration()
    var
        TempJobTask: Record "Job Task" temporary;
        JobUtilities: Codeunit "Job Utilities";
        ProgressDialog: Dialog;
    begin
        ProgressDialog.Open(GeneratingTextDialogTxt);
        JobUtilities.GetActivitiesSuggestion(TempCurrentJob, InputProjectDescription, TempJobTask, TempJobPlanningLine, SimulationBudget);

        CurrPage.ProjectAIResponseSubpage.Page.ReadFrom(TempJobTask);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::OK then
            CurrPage.ProjectAIResponseSubpage.Page.WriteTo(TempResultJobTask);
    end;

    procedure WriteTo(var TempJobTaskToWrite: Record "Job Task" temporary; var TempJobPlanningLineToWrite: Record "Job Planning Line" temporary)
    begin

        TempResultJobTask.Reset();
        if TempResultJobTask.FindSet() then
            repeat

                TempJobTaskToWrite.Init();
                TempJobTaskToWrite.TransferFields(TempResultJobTask);
                TempJobTaskToWrite.Insert(false);

            until TempResultJobTask.Next() = 0;

        TempJobPlanningLine.Reset();
        if TempJobPlanningLine.FindSet() then
            repeat

                TempJobPlanningLineToWrite.Init();
                TempJobPlanningLineToWrite.TransferFields(TempJobPlanningLine);
                TempJobPlanningLineToWrite.Insert(false);

            until TempJobPlanningLine.Next() = 0;
    end;

    //Variabili
    var
        TempCurrentJob: Record Job temporary;
        TempResultJobTask: Record "Job Task" temporary;
        TempJobPlanningLine: Record "Job Planning Line" temporary;
        InputProjectDescription: Text;
        GeneratingTextDialogTxt: Label 'Generating with Copilot...';
        SimulationBudget: Enum "Simulation Prompt Options";
}
