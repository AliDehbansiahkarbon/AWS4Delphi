program SampleSNS;

uses
  Vcl.Forms,
  FSampleSNS in 'FSampleSNS.pas' {Form1},
  AWS4D.SNS.Service in '..\..\Source\SNS\AWS4D.SNS.Service.pas',
  AWS4D.SNS.Service.Interfaces in '..\..\Source\SNS\AWS4D.SNS.Service.Interfaces.pas',
  AWS4D.SNS.Model.Interfaces in '..\..\Source\SNS\AWS4D.SNS.Model.Interfaces.pas',
  AWS4D.SNS.Model.ListTopics.Request in '..\..\Source\SNS\AWS4D.SNS.Model.ListTopics.Request.pas',
  AWS4D.SNS.Model.ListTopics.Response in '..\..\Source\SNS\AWS4D.SNS.Model.ListTopics.Response.pas',
  AWS4D.Core.Helper.JSON in '..\..\Source\Core\AWS4D.Core.Helper.JSON.pas',
  AWS4D.Core.Model.Attribute in '..\..\Source\Core\AWS4D.Core.Model.Attribute.pas',
  AWS4D.Core.Model.Classes in '..\..\Source\Core\AWS4D.Core.Model.Classes.pas',
  AWS4D.Core.Model.Iterator in '..\..\Source\Core\AWS4D.Core.Model.Iterator.pas',
  AWS4D.Core.Model.Tag in '..\..\Source\Core\AWS4D.Core.Model.Tag.pas',
  AWS4D.Core.Model.Types in '..\..\Source\Core\AWS4D.Core.Model.Types.pas',
  AWS4D.SNS.Facade.Interfaces in '..\..\Source\SNS\AWS4D.SNS.Facade.Interfaces.pas',
  AWS4D.SNS.Facade.ListTopics in '..\..\Source\SNS\AWS4D.SNS.Facade.ListTopics.pas',
  AWS4D.SNS.Facade in '..\..\Source\SNS\AWS4D.SNS.Facade.pas';

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
