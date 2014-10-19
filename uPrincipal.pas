unit uPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBServices, SkinData, DynamicSkinForm, StdCtrls, Mask,
  SkinBoxCtrls, SkinCtrls, spSkinShellCtrls,FileCtrl;

type
  TfPrincipal = class(TForm)
    Backup: TIBBackupService;
    spDynamicSkinForm1: TspDynamicSkinForm;
    spSkinData1: TspSkinData;
    spCompressedSkinList1: TspCompressedSkinList;
    spResourceStrData1: TspResourceStrData;
    spSkinLabel1: TspSkinLabel;
    txtServidor: TspSkinEdit;
    spSkinLabel2: TspSkinLabel;
    txtBanco: TspSkinEdit;
    spSkinButton1: TspSkinButton;
    Memo1: TspSkinMemo;
    spSkinButton2: TspSkinButton;
    Restore: TIBRestoreService;
    spSkinButton3: TspSkinButton;
    boxSobrescrever: TspSkinCheckRadioBox;
    spSkinLabel3: TspSkinLabel;
    txtRec: TspSkinEdit;
    dg1: TOpenDialog;
    dg3: TOpenDialog;
    spSkinButton4: TspSkinButton;
    procedure spSkinButton2Click(Sender: TObject);
    procedure spSkinButton1Click(Sender: TObject);
    procedure spSkinButton3Click(Sender: TObject);
    procedure spSkinButton4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

{$R *.dfm}

procedure TfPrincipal.spSkinButton2Click(Sender: TObject);
var
  zArqBackup : string;
begin
 if not FileExists(txtBanco.Text) then
   Begin
     Application.MessageBox('Arquivo de Banco de Dados Inválido !','Atenção',MB_OK+ MB_ICONQUESTION );
     txtBanco.SetFocus;
     Exit;
   End;
 if Application.MessageBox('Deseja fazer o Backup Agora?','Atenção',MB_YESNO+ MB_ICONQUESTION )= IDNO then
   Exit;
  zArqBackup := ExtractFilePath(Application.ExeName) + '\backup' + FormatDateTime('dd-mm-yyyy',date)+ FormatDateTime('hhmm',date)+'.fbk';
 with Backup do
  begin
    ServerName := txtServidor.Text ;
    LoginPrompt := False;
    Params.Add('user_name=sysdba');
    Params.Add('password=masterkey');
    Active := True;
    try
      Verbose := True;
      Options := [NonTransportable, IgnoreLimbo];
      DatabaseName := txtBanco.Text ;
      BackupFile.Add(zArqBackup);

      ServiceStart;
      While not Eof do
        Memo1.Lines.Add(GetNextLine);
    finally
      Active := False;
    end;
  end;
end;

procedure TfPrincipal.spSkinButton1Click(Sender: TObject);
begin
  dg1.Execute;
  txtBanco.Text := dg1.FileName;
end;

procedure TfPrincipal.spSkinButton3Click(Sender: TObject);
Var
Diretorio  : String;
begin
   with Restore do
  begin
    if not DirectoryExists(ExtractFileDir(txtRec.Text)) then
      begin
       Application.MessageBox('Informe o caminho/nome do arquivo para restauração!','Atenção',MB_OK+ MB_ICONINFORMATION);
       txtRec.SetFocus;
       Exit;
      end;
    ServerName := txtServidor.Text ;
    LoginPrompt := False;
    Params.Add('user_name=sysdba');
    Params.Add('password=masterkey');
    Active := True;
    try
      Verbose := True;
      if boxSobrescrever.Checked then
          Options := [Replace, UseAllSpace]
      else
          Options := [UseAllSpace,CreateNewDB];
      
      if txtRec.Text ='' then
        SelectDirectory('Selecionar Pasta','',Diretorio);

      Restore.DatabaseName.Add(txtRec.Text);
      PageBuffers := 3000;
      PageSize := 4096;
      dg3.Execute;
      if not FileExists(dg3.FileName) then
        begin
          Application.MessageBox('Arquivo de Backup Inválido!','',MB_OK+ MB_ICONINFORMATION);
          txtRec.SetFocus;
          Exit;
        end;

      Restore.BackupFile.Add(dg3.FileName);
      ServiceStart;
      While not Eof do
        Memo1.Lines.Add(GetNextLine);
      Memo1.Lines.Add('Restore Finalizado : ' + DateTimeToStr (now))
    finally
      Active := False;
    end;
  end;
end;

procedure TfPrincipal.spSkinButton4Click(Sender: TObject);
var
  Diretorio : string;
begin
  SelectDirectory('Selecionar Pasta','',Diretorio);
  if Diretorio <> '' then
  txtRec.Text := Diretorio +'banco.fdb';
end;

end.
