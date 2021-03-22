;Written by M.Enes Başarkan
!define TEMP1 $R0 ;Değişken tanımlanır.
;--------------------------------
!include "MUI2.nsh" ;Gerekli kütüphaneler import edilir.(Modern User Interface 2) 
;--------------------------------
;Genel
  Name "AcronAr-Ge" ;Yükleyicinin adı.
  OutFile "setupacron.exe" ;Yükleyici dosya adı.
  Unicode True ; Karakter desteği için unicode açılır.
  InstallDir $PROGRAMFILES\AcronArGe ;Yüklemenin yapılacağı dosya.
  DirText "Lütfen dosya yolunu seciniz."
;--------------------------------
;Interface Ayarları
  !define MUI_ICON "C:\Users\enes.basarkan\Desktop\SetupWizard\icon.ico" ;Setup dosyası ve başlık iconunu değiştirir.
  !define MUI_ABORTWARNING
;--------------------------------
;Yükleme için Sayfalar
  !insertmacro MUI_PAGE_WELCOME ;Hoşgeldin sayfası.
  Page custom SetCustom "" ": Kullanici Adi ve Sifre" ;özel sayfa oluşturma.(Kullanıcı adı ve şifre girilmesi için)
  !insertmacro MUI_PAGE_LICENSE "C:\Users\enes.basarkan\Desktop\SetupWizard\Tkinter\myLicense.txt" ;Arzu edilen lisans dökümanın onaylanması için sayfa.
  !insertmacro MUI_PAGE_COMPONENTS ;Birden çok dosyanın yüklenmesi ve seçilmesini sağlayan sayfa.
  !insertmacro MUI_PAGE_DIRECTORY ;Yükleme yapılacağı dosyanın değiştirilmesini sağlayan sayfa.
  !insertmacro MUI_PAGE_INSTFILES ;Yüklenme durumu.
  !insertmacro MUI_PAGE_FINISH ;Bitiş sayfası.
;--------------------------------
;Silmek için Sayfalar
  !insertmacro MUI_UNPAGE_WELCOME ;Hoşgeldin sayfası.
  !insertmacro MUI_UNPAGE_CONFIRM ;Onay sayfası.
  !insertmacro MUI_UNPAGE_INSTFILES ;Yüklenme durumu.
  !insertmacro MUI_UNPAGE_FINISH ;Bitiş sayfası.
;--------------------------------
;Dil Desteği
!insertmacro MUI_LANGUAGE "Turkish" ;Arayüz dil seçimi.
;--------------------------------
;UsernameSection
Function .onInit
  StrCpy $2 0
  InitPluginsDir
  File /oname=$PLUGINSDIR\up.ini "up.ini"
FunctionEnd
;-------------------------
Function SetCustom
  ;Display the InstallOptions dialog
  Push ${TEMP1}
    again: InstallOptions::dialog "$PLUGINSDIR\up.ini"    
  Pop ${TEMP1}
 
  StrCmp ${TEMP1} "success" 0 continue
  ReadINIStr $0 "$PLUGINSDIR\up.ini" "Field 1" "State"
  ReadINIStr $1 "$PLUGINSDIR\up.ini" "Field 2" "State"
 
  StrCmp $0 "enesbasarkan" 0 +2
    StrCmp $1 "acron" continue wrong
  StrCmp $0 "ramazandirek" 0 +2
    StrCmp $1 "acron" continue wrong
  StrCmp $0 "admin" 0 +2
    StrCmp $1 "admin" continue wrong
 
  wrong:
    IntOp $2 $2 + 1
	StrCmp $2 3 kill
    MessageBox MB_OK|MB_ICONSTOP "Yanlis Kullanici Adi veya Sifre. Lutfen Tekrar Deneyiniz..."  
  Goto again
 
  continue: Pop ${TEMP1}
  Return
 
  kill: MessageBox MB_OK|MB_ICONSTOP "3 Kez Yanlis Girdiniz..."
  Quit
 
FunctionEnd
;Section yüklenecek parçacıklar belirlenir.
;--------------------------------
Section "Visual Studio Runtime" ;Bölüm adı belirlenir. 
  SetOutPath "$INSTDIR" ;Dosyanın yükleneceği yol verilir. (INSTDIR = InstallDir)
  File "C:\Users\enes.basarkan\Desktop\SetupWizard\Tkinter\VC_redist.x64.exe" ;Yüklenecek dosyanın yolu verilir.
  ExecWait "$INSTDIR\VC_redist.x64.exe" ;Yüklecen dosya farklı bir setup dosyası ise ExecWait kullanılır.
  Delete "$INSTDIR\VC_redist.x64.exe" ;Dosyanın silinmesini sağlar.
SectionEnd
;--------------------------------
Section "Acron Deprem Uygulamasi" SecDummy
  SectionIn RO ;Bölümün kurulumunu zorunlu kılar.
  SetOutPath "$INSTDIR" ;Dosyanın yükleneceği yol verilir. (INSTDIR = InstallDir)
  File /r "C:\Users\enes.basarkan\Desktop\SetupWizard\Tkinter\*" ;Yüklenecek dosyanın yolu verilir.
  WriteUninstaller "$INSTDIR\Uninstall.exe" ;Kurulum için silici kurulur.
SectionEnd
;--------------------------------
Section "Acron HES Uygulamasi" SecDummy2
  SetOutPath "$INSTDIR" ;Dosyanın yükleneceği yol verilir. (INSTDIR = InstallDir)
  File /r "C:\Users\enes.basarkan\Desktop\SetupWizard\Hes\*" ;Yüklenecek dosyanın yolu verilir.
SectionEnd
;--------------------------------
Section /o "Masaustu Kisayol"
  CreateShortCut "$DESKTOP\main.lnk" "$INSTDIR\dist\main.exe" ;Kısayol oluşturur.
SectionEnd
;--------------------------------
;Açıklamalar
  ;Açıklama için değişken belirlemek.
  LangString DESC_SecDummy ${LANG_TURKISH} "Deprem algilama icin gerceklestirilmis uygulamadir." ;SecDummy için açıklama metni değişkene atanır.
  LangString DESC_SecDummy2 ${LANG_TURKISH} "HES icin gerceklestirilmis uygulamadir." ;SecDummy için açıklama metni değişkene atanır.
  ;Değişkenleri bölümlere atamak.
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy2} $(DESC_SecDummy2)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
;--------------------------------
;Silmek İçin
Section "Uninstall"
  Delete $INSTDIR\Uninstall.exe ;exe'yi siler.
  RMDir /R /REBOOTOK $INSTDIR
SectionEnd
;--------------------------------