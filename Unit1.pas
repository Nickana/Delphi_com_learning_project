unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPort, ExtCtrls, CPortCtl, Vcl.Menus{high-precision timer};

type
  TForm1 = class(TForm)
    ComPort1: TComPort;
    ConnectButton: TButton;
    memo: TMemo;
    ComDataPacket1: TComDataPacket;
    SendButton: TButton;
    DisconnectButton: TButton;
    Panel1: TPanel;
    SettingButton: TButton;
    chat_memo: TMemo;
    Label1: TLabel;
    GreenLed: TPanel;
    RedLed: TPanel;
    BlueLed: TPanel;
    Timer1: TTimer;
    OutputRadioGroup: TRadioGroup;
    label2: TLabel;


    procedure SettingButtonClick(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure DisconnectButtonClick(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure ComDataPacket1Packet(Sender: TObject; const Str: String);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

    function StringToHex(str: String) : string;
    function StringToBinary(str:string) : string;

  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  Form1: TForm1;
  GreenOffLed: TColor;
  GreenOnLed: TColor;
  RedOffLed: TColor;
  RedOnLed: TColor;
  BlueOnLed: TColor;
  BlueOffLed: TColor;
  tick: Integer;
  tick2: integer;

  TimerID : UINT;{indentifi timer}


implementation

uses StrUtils;

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);{������������� ����� � ��������� ���������� ����������}
begin
     GreenOffLed := RGB(0,64,0);
     GreenOnLed := RGB(0,255,0);
     RedOffLed := RGB(64,0,0);
     RedOnLed := RGB(255,0,0);
     BlueOffLed := RGB(0,0,64);
     BlueOnLed := RGB (61,164,255);
     tick:= 0;
     tick2:=0;

end;


{My function's--------------------------------------}
function TForm1.StringToBinary(str: string): string;
var
  z: integer;
  i: integer;
  symbol: char;
begin
  result := '';
  for i := 1 to Length(str) do
    begin
      symbol:= str[i];
      begin
        for z := 0 to 8 - 1 do
          if Integer(symbol) and (1 shl z) > 0 then
          result := '1' + result
        else
          result := '0' + result;
      end;
      if i < Length(str) then
      begin
        result:= '  ' + result;
      end;
    end;


end;

function TForm1.StringToHex(str: String): string;
var
  i:integer;
  symbol: char;
  begin
  result:= '';
    for i := 1 to Length(str) do
      begin
        symbol:= str[i];
        result := result + IntToHex(Integer(symbol),2) + ' ';
      end;
  end;

{----------------------------------------------------}

procedure TForm1.SettingButtonClick(Sender: TObject);
begin
 ComPort1.ShowSetupDialog();
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin

  tick := tick+1;
  if (tick mod  2 > 0) then
      begin
        BlueLed.Color := BlueOnLed;
      end
    else
      begin
          BlueLed.Color := BlueOffLed;
      end;

  if tick = 8 then
    begin
      Timer1.Enabled := False;
      tick := 0;
    end;

end;


procedure TForm1.ConnectButtonClick(Sender: TObject);

begin

  try
    ComPort1.Open
  except
    ShowMessage('Failed connection to this com-port!')
    end;
  if ComPort1.Connected then
    begin
    GreenLed.Color := GreenOnLed;
    RedLed.Color := RedOffLed;
    SendButton.Enabled := True;
    chat_memo.Enabled := True;
    OutputRadioGroup.Enabled := True;
    end;

end;

procedure TForm1.DisconnectButtonClick(Sender: TObject);
begin
  if  ComPort1.Connected then
    begin
      ComPort1.Close;
      RedLed.Color := RedOnLed;
      GreenLed.Color := GreenOffLed;
      SendButton.Enabled := False;
      chat_memo.Enabled := False;
      OutputRadioGroup.Enabled := False;
    end
  else
    ShowMessage('com port is not connected if what nah...')

end;


procedure TForm1.SendButtonClick(Sender: TObject);
var
i:Integer;
Line: string;


begin
  Timer1.Enabled :=True;
     for i := 0 to chat_memo.Lines.Count-1 do
      begin
      Line := chat_memo.Lines.Strings[i];
      ComPort1.WriteStr(Line);
      end;
end;


procedure TForm1.ComDataPacket1Packet(Sender: TObject; const Str: String);

begin
  case OutputRadioGroup.ItemIndex of
    0: memo.Lines.Add(Str);
    1: memo.Lines.Add(StringToHex(Str));
    2: memo.Lines.Add(StringToBinary(Str));
  end;

  end;

end.
