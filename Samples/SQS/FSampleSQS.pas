unit FSampleSQS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  AWS4D.SQS.Model.Interfaces,
  AWS4D.SQS.Service.Interfaces,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.IniFiles,
  REST.Json,
  System.JSON, Vcl.Grids, Vcl.ValEdit;

type
  TSQSConfig = class
  private
    FaccessKeyId: string;
    FsecretKey: string;
    Fregion: String;
  public
    property accessKeyId: string read FaccessKeyId write FaccessKeyId;
    property secretKey: string read FsecretKey write FsecretKey;
    property region: String read Fregion write Fregion;
  end;

  TForm2 = class(TForm)
    pnlTop: TPanel;
    pnlHeader: TPanel;
    Label1: TLabel;
    edtAccessKey: TEdit;
    edtSecretKey: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtRegion: TEdit;
    pgcSQS: TPageControl;
    tsListQueues: TTabSheet;
    Panel1: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtListQueuesQueuePrefix: TEdit;
    edtListQueuesMaxResult: TEdit;
    edtListQueuesNextToken: TEdit;
    btnListQueues: TButton;
    mmoListQueues: TMemo;
    tsListQueueTags: TTabSheet;
    Panel2: TPanel;
    Label7: TLabel;
    edtListQueueTagsQueueName: TEdit;
    btnListQueueTags: TButton;
    mmoListQueueTags: TMemo;
    tsReceiveMessage: TTabSheet;
    Panel3: TPanel;
    Label8: TLabel;
    edtReceiveMessageQueueName: TEdit;
    btnReceiveMessage: TButton;
    tsGetQueueUrl: TTabSheet;
    Panel4: TPanel;
    Label9: TLabel;
    edtGetQueueUrlQueueName: TEdit;
    btnGetQueueUrl: TButton;
    mmoGetQueueUrl: TMemo;
    Label10: TLabel;
    edtReceiveMessageMaxNumberMessages: TEdit;
    Label11: TLabel;
    edtReceiveMessageVisibilityTimeout: TEdit;
    mmoReceiveMessageResponse: TMemo;
    tsSendMessage: TTabSheet;
    Panel5: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    edtSendMessageQueueName: TEdit;
    btnSendMessage: TButton;
    edtSendMessageMessageBody: TEdit;
    mmoSendMessage: TMemo;
    tsDeleteMessage: TTabSheet;
    Panel6: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    edtDeleteMessageQueueName: TEdit;
    btnDeleteMessage: TButton;
    edtDeleteMessageReceiptHandle: TEdit;
    mmoDeleteMessage: TMemo;
    tsCreateQueue: TTabSheet;
    Panel7: TPanel;
    Label16: TLabel;
    edtCreateQueueQueueName: TEdit;
    btnCreateQueue: TButton;
    mmoCreateQueue: TMemo;
    tsDeleteMessageBatch: TTabSheet;
    Panel8: TPanel;
    Label17: TLabel;
    edtDeleteMessageBatchQueueName: TEdit;
    btnDeleteMessageBatch: TButton;
    edtDeleteMessageBatchList: TValueListEditor;
    mmoDeleteMessageBatch: TMemo;
    procedure btnListQueuesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnListQueueTagsClick(Sender: TObject);
    procedure btnQueueURLClick(Sender: TObject);
    procedure btnReceiveMessageClick(Sender: TObject);
    procedure btnSendMessageClick(Sender: TObject);
    procedure btnDeleteMessageClick(Sender: TObject);
    procedure btnCreateQueueClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteMessageBatchClick(Sender: TObject);
  private
    { Private declarations }
    function GetIniFile: TIniFile;
    procedure SaveConfig;
    procedure LoadConfig;

    function CreateSQS: IAWS4DServiceSQS;

    procedure writeCreateQueueResponse(Response: IAWS4DSQSModelCreateQueueResponse);
    procedure writeDeleteMessageResponse(Response: IAWS4DSQSModelDeleteMessageResponse);
    procedure writeDeleteMessageBatchResponse(Response: IAWS4DSQSModelDeleteMessageBatchResponse);
    procedure writeGetQueueUrlResponse(Response: IAWS4DSQSModelGetQueueUrlResponse);
    procedure writeListQueuesResponse(Response: IAWS4DSQSModelListQueuesResponse);
    procedure writeListQueueTagsResponse(Response: IAWS4DSQSModelListQueueTagsResponse);
    procedure writeReceiveMessageResponse(Response: IAWS4DSQSModelReceiveMessageResponse);
    procedure writeSendMessageResponse(Response: IAWS4DSQSModelSendMessageResponse);

    procedure writeHTTPException(AException: EAWS4DHTTPException);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btnCreateQueueClick(Sender: TObject);
var
  request: IAWS4DSQSModelCreateQueueRequest;
  response: IAWS4DSQSModelCreateQueueResponse;
begin
  request := SQSModelFactory.CreateQueueRequest;
  request.QueueName(edtCreateQueueQueueName.Text);

  response := CreateSQS.CreateQueue(request);
  writeCreateQueueResponse(response);
end;

procedure TForm2.btnDeleteMessageBatchClick(Sender: TObject);
var
  request: IAWS4DSQSModelDeleteMessageBatchRequest;
  response: IAWS4DSQSModelDeleteMessageBatchResponse;
  messageId: string;
  receiptHandle: string;
  i : Integer;
begin
  request := SQSModelFactory.DeleteMessageBatchRequest;
  request.QueueUrl(edtDeleteMessageBatchQueueName.Text);

  for i := 0 to edtDeleteMessageBatchList.Strings.Count - 1 do
  begin
    messageId := edtDeleteMessageBatchList.Strings.Names[i];
    receiptHandle := edtDeleteMessageBatchList.Strings.ValueFromIndex[i];

    request.AddReceiptHandle(messageId, receiptHandle);
  end;

  response := CreateSQS.DeleteMessageBatch(request);
  writeDeleteMessageBatchResponse(response);
end;

procedure TForm2.btnDeleteMessageClick(Sender: TObject);
var
  request: IAWS4DSQSModelDeleteMessageRequest;
  response : IAWS4DSQSModelDeleteMessageResponse;
begin
  request := SQSModelFactory.DeleteMessageRequest;
  request
    .QueueUrl(edtDeleteMessageQueueName.Text)
    .ReceiptHandle(edtDeleteMessageReceiptHandle.Text);

  response := CreateSQS.DeleteMessage(request);
  writeDeleteMessageResponse(response);
end;

procedure TForm2.btnListQueuesClick(Sender: TObject);
var
  response : IAWS4DSQSModelListQueuesResponse;
  request  : IAWS4DSQSModelListQueuesRequest;
begin
  request := SQSModelFactory.ListQueuesRequest;
  request
    .QueueNamePrefix(edtListQueuesQueuePrefix.Text)
    .MaxResults(StrToIntDef(edtListQueuesMaxResult.Text, 0))
    .NextToken(edtListQueuesNextToken.Text);

  try
    response := CreateSQS.ListQueues(request);
    writeListQueuesResponse(response);
  except
    on e : EAWS4DHTTPException do
    begin
      writeHTTPException(e);
      raise;
    end;
  end;
end;

procedure TForm2.btnListQueueTagsClick(Sender: TObject);
var
  response: IAWS4DSQSModelListQueueTagsResponse;
begin
  response := CreateSQS.ListQueueTags(edtListQueueTagsQueueName.Text);
  writeListQueueTagsResponse(response);
end;

procedure TForm2.btnQueueURLClick(Sender: TObject);
var
  response : IAWS4DSQSModelGetQueueUrlResponse;
begin
  response := CreateSQS.GetQueueUrl('Send-to-Email-Docfiscal-dev');
  writeGetQueueUrlResponse(response);
end;

procedure TForm2.btnReceiveMessageClick(Sender: TObject);
var
  request: IAWS4DSQSModelReceiveMessageRequest;
  response : IAWS4DSQSModelReceiveMessageResponse;
begin
  request := SQSModelFactory.ReceiveMessageRequest;
  request
    .queueUrl(edtReceiveMessageQueueName.Text)
    .maxNumberOfMessages(StrToIntDef(edtReceiveMessageMaxNumberMessages.Text, -1))
    .visibilityTimeout(StrToIntDef(edtReceiveMessageVisibilityTimeout.Text, -1));

  response := CreateSQS.ReceiveMessage(request);
  writeReceiveMessageResponse(response);
end;

procedure TForm2.btnSendMessageClick(Sender: TObject);
var
  request: IAWS4DSQSModelSendMessageRequest;
  response: IAWS4DSQSModelSendMessageResponse;
begin
  request := SQSModelFactory.SendMessageRequest;
  request
    .QueueUrl(edtSendMessageQueueName.Text)
    .MessageBody(edtSendMessageMessageBody.Text);

  response := CreateSQS.SendMessage(request);
  writeSendMessageResponse(response);
end;

function TForm2.CreateSQS: IAWS4DServiceSQS;
begin
  result := SQSService;
  result
    .AccessKeyID(edtAccessKey.Text)
    .Region(edtRegion.Text)
    .SecretKey(edtSecretKey.Text);
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveConfig;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  LoadConfig;
  edtSendMessageMessageBody.Text := Format('Message Test %s', [FormatDateTime('dd/MM/yyyy hh:mm:ss', Now)]);
end;

function TForm2.GetIniFile: TIniFile;
var
  path : String;
begin
  path := ExtractFilePath(GetModuleName(HInstance)) + 'SampleSQS.ini';
  result := TIniFile.Create(path);
end;

procedure TForm2.LoadConfig;
var
  iniFile   : TIniFile;
begin
  iniFile := GetIniFile;
  try
    edtAccessKey.Text := iniFile.ReadString('SQS', 'ACCESS_KEY', EmptyStr);
    edtSecretKey.Text := iniFile.ReadString('SQS', 'SECRET_KEY', EmptyStr);
    edtRegion.Text    := iniFile.ReadString('SQS', 'REGION', EmptyStr);
  finally
    iniFile.Free;
  end;
end;

procedure TForm2.SaveConfig;
var
  iniFile: TIniFile;
begin
  iniFile := GetIniFile;
  try
    iniFile.WriteString('SQS', 'ACCESS_KEY', edtAccessKey.Text);
    iniFile.WriteString('SQS', 'SECRET_KEY', edtSecretKey.Text);
    iniFile.WriteString('SQS', 'REGION', edtRegion.Text);
  finally
    iniFile.Free;
  end;
end;

procedure TForm2.writeCreateQueueResponse(Response: IAWS4DSQSModelCreateQueueResponse);
begin
  mmoCreateQueue.Lines.Clear;
  mmoCreateQueue.Lines.Add('RequestID: ' + Response.RequestId);
  mmoCreateQueue.Lines.Add('Queue Url: ' + Response.QueueUrl);
end;

procedure TForm2.writeDeleteMessageBatchResponse(Response: IAWS4DSQSModelDeleteMessageBatchResponse);
var
  i : Integer;
begin
  mmoDeleteMessageBatch.Lines.Clear;
  mmoDeleteMessageBatch.Lines.Add('RequestID: ' + Response.RequestId);
  mmoDeleteMessageBatch.Lines.Add(EmptyStr);

  mmoDeleteMessageBatch.Lines.Add('Successful Ids');
  for i := 0 to Pred(Response.Successful.Count) do
    mmoDeleteMessageBatch.Lines.Add(Response.Successful[i]);
end;

procedure TForm2.writeDeleteMessageResponse(Response: IAWS4DSQSModelDeleteMessageResponse);
begin
  mmoDeleteMessage.Lines.Clear;
  mmoDeleteMessage.Lines.Add('RequestID: ' + Response.RequestId);
end;

procedure TForm2.writeGetQueueUrlResponse(Response: IAWS4DSQSModelGetQueueUrlResponse);
begin
  mmoGetQueueUrl.Lines.Clear;
  mmoGetQueueUrl.Lines.Add('RequestID: ' + Response.RequestId);

  mmoGetQueueUrl.Lines.Add('Url = ' + Response.QueueUrl);
end;

procedure TForm2.writeHTTPException(AException: EAWS4DHTTPException);
begin
  mmoListQueues.Lines.Clear;
  mmoListQueues.Lines.Add('RequestID: ' + AException.RequestId);
  mmoListQueues.Lines.Add('Code: '      + AException.Code);
  mmoListQueues.Lines.Add('Message: '   + AException.Message);
  mmoListQueues.Lines.Add('Type: '      + AException.&Type);
end;

procedure TForm2.writeListQueuesResponse(Response: IAWS4DSQSModelListQueuesResponse);
var
  i : Integer;
begin
  edtListQueuesNextToken.Clear;
  mmoListQueues.Lines.Clear;
  mmoListQueues.Lines.Add('RequestID: ' + Response.RequestId);
  if not Response.NextToken.IsEmpty then
  begin
    edtListQueuesNextToken.Text := Response.NextToken;
    mmoListQueues.Lines.Add('NextToken: ' + Response.NextToken);
  end;

  mmoListQueues.Lines.Add('Queues---------');
  for i := 0 to Pred(Response.QueuesUrls.Count) do
    mmoListQueues.Lines.Add(Response.QueuesUrls[i]);
end;

procedure TForm2.writeListQueueTagsResponse(Response: IAWS4DSQSModelListQueueTagsResponse);
var
  key: string;
begin
  mmoListQueueTags.Lines.Clear;
  mmoListQueueTags.Lines.Add('RequestID: ' + Response.RequestId);

  mmoListQueueTags.Lines.Add('Tags ---------');
  for key in Response.Tags.Keys do
    mmoListQueueTags.Lines.Add(key + '=' + Response.Tags.Items[key]);
end;

procedure TForm2.writeReceiveMessageResponse(Response: IAWS4DSQSModelReceiveMessageResponse);
var
  receiveMessage: IAWS4DSQSModelReceiveMessage;
  key : string;
begin
  mmoReceiveMessageResponse.Clear;
  mmoReceiveMessageResponse.Lines.Add('RequestID: ' + Response.RequestId);

  for receiveMessage in Response.Messages do
  begin
    mmoReceiveMessageResponse.Lines.Add('MessageId: ' + receiveMessage.MessageId);
    mmoReceiveMessageResponse.Lines.Add('MD5OfBody: ' + receiveMessage.MD5OfBody);
    mmoReceiveMessageResponse.Lines.Add('Body: ' + receiveMessage.Body);
    mmoReceiveMessageResponse.Lines.Add('ReceiptHandle: ' + receiveMessage.ReceiptHandle);

    edtDeleteMessageReceiptHandle.Text := receiveMessage.ReceiptHandle;

    mmoReceiveMessageResponse.Lines.Add('Attributes -----');
    for key in receiveMessage.Attributes.Keys do
      mmoReceiveMessageResponse.Lines.Add(key + ' = ' + receiveMessage.Attributes.Items[key]);
  end;
end;

procedure TForm2.writeSendMessageResponse(Response: IAWS4DSQSModelSendMessageResponse);
begin
  mmoSendMessage.Clear;
  mmoSendMessage.Lines.Add('RequestID: ' + Response.RequestId);
  mmoSendMessage.Lines.Add('MessageId: ' + Response.MessageId);
  mmoSendMessage.Lines.Add('MD5OfMessageBody: ' + Response.MD5OfMessageBody);
  mmoSendMessage.Lines.Add('SequenceNumber: ' + Response.SequenceNumber);
end;

end.
