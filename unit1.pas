unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLite3Conn, SQLDBLib, SQLDB, Forms, Controls,
  Graphics, Dialogs, DBGrids, LazFileUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    ds: TDataSource;
    grConn: TDBGrid;
    LibLoader: TSQLDBLibraryLoader;
    tmpConn: TSQLite3Connection;
    tmpQry: TSQLQuery;
    tmpTrans: TSQLTransaction;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

const
  SQLText =
    'SELECT ' +
        'P.ID' +
        ',P.LASTNAME' +
        ', P.FIRSTNAME' +
        ', P.THIRDNAME' +
        ', P.DATEBORN' +
        ', iif(P.SEX = 1,''male'',''female'') AS SEX ' +
    'FROM PERSONALITY P';

    SQLText_cnt =
    'SELECT count(P.ID) AS CNT ' +
    'FROM PERSONALITY P';


  DBFileName = 'base\test_base.db';
  LibFileName = 'sqlite_lib_x64\sqlite3.dll';

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  LibLoader.ConnectionType:= 'SQLite3';
  LibLoader.LibraryName:= CleanAndExpandDirectory(ExtractFilePath(Application.ExeName)) + LibFileName;
  tmpConn.CharSet:= 'UTF8';
  tmpConn.DatabaseName:= CleanAndExpandDirectory(ExtractFilePath(Application.ExeName)) + DBFileName;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  tc, tc_cnt: QWord;
begin
  LibLoader.Enabled:= True;
  tmpConn.Connected:= True;
  try
    tc:= GetTickCount64;
    tmpQry.DisableControls;
    try
      //tmpTrans.Active:= True;
      //tmpTrans.StartTransaction;

      //tmpQry.Active:= False;
      tmpQry.SQL.Text:= SQLText_cnt;
      tmpQry.Active:= True;

      tc_cnt:= GetTickCount64 - tc;
      tc:= GetTickCount64;
      tmpTrans.Active:= False;

      //tmpTrans.Active:= True;
      tmpQry.Active:= False;
      tmpQry.SQL.Text:= SQLText;
      tmpQry.Active:= True;
      tmpQry.Last;
      tmpQry.First;

      //tmpTrans.Active:= False;

      //tmpTrans.Commit;
    except
      on E:Exception do
      begin
        //tmpTrans.Rollback;
        ShowMessage(E.Message);
      end;
    end;
  finally
    tmpQry.EnableControls;
    Self.Caption:= Format('Time fetching for - record count: %d ms/- 100K records %d ms', [tc_cnt, GetTickCount64 - tc]);
  end;
end;

end.

