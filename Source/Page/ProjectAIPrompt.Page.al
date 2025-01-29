namespace ProjectAI.ProjectAI;
using ProjectAI.Utilities;
using Microsoft.Projects.Project.Job;

page 60100 "Project AI Prompt"
{
    PageType = PromptDialog;
    Extensible = false; //Obbligatorio
    SourceTable = Job;
    SourceTableTemporary = true;

    ApplicationArea = All;
    UsageCategory = Administration;

    //PromptMode = Content;
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
            part(JobTaskLinesSubform; "Job Task Lines Subform")
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

    local procedure RunGeneration()
    var
        TempJobTask: Record "Job Task" temporary;
        ProjectUtilities: Codeunit "Project Utilities";
        ProgressDialog: Dialog;
    begin
        ProgressDialog.Open(GeneratingTextDialogTxt);
        ProjectUtilities.GetActivitiesSuggestion(Rec, InputProjectDescription, TempJobTask);

        CurrPage.JobTaskLinesSubform.Page.Load(TempJobTask);

        if GetLastErrorText() = '' then
            Error(SomethingWentWrongErr)
        else
            Error(SomethingWentWrongWithLatestErr, GetLastErrorText());
    end;

    //Variabili
    var
        InputProjectDescription: Text;
        GeneratingTextDialogTxt: Label 'Generating with Copilot...';
        SomethingWentWrongErr: Label 'Something went wrong. Please try again.';
        SomethingWentWrongWithLatestErr: Label 'Something went wrong. Please try again. The latest error is: %1', Comment = '%1 = Last Error Message';
}
