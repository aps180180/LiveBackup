program LiveBackup;

uses
  Forms,
  uPrincipal in 'uPrincipal.pas' {fPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
